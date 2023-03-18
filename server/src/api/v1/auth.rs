use argon2::{Argon2, PasswordHash, PasswordHasher, PasswordVerifier};
use axum::{Extension, Json};
use migration::{Expr, IntoCondition};
use password_hash::SaltString;
use rand_core::OsRng;
use sea_orm::prelude::Uuid;
use sea_orm::{
    ActiveValue, ColumnTrait, DatabaseConnection, EntityTrait, PaginatorTrait,
    QueryFilter, QuerySelect, RelationTrait, TransactionTrait,
};
use serde::{Deserialize, Serialize};
use validator::Validate;

use crate::entity::{role, user, user_role};
use crate::error::{Error, UnauthorizedType};
use crate::session::generate_session;
use crate::user::User;

use super::JsonSuccess;

#[derive(Debug, Serialize, Deserialize, Validate, Clone)]
pub struct AuthRequest {
    #[validate(email)]
    pub email: String,
    #[validate(length(min = 8, max = 64))]
    pub password: String,
}

#[derive(Debug, Serialize, Deserialize, Clone, PartialEq)]
pub struct RoleResponse {
    id: i32,
    name: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct LoginResponse {
    pub roles: Vec<RoleResponse>,
    pub session: String,
}

pub async fn login(
    Extension(db): Extension<DatabaseConnection>,
    Json(auth): Json<AuthRequest>,
) -> Result<JsonSuccess<LoginResponse>, Error> {
    auth.validate()?;

    let user = user::Entity::find()
        .filter(user::Column::Email.eq(auth.email.clone()))
        .one(&db)
        .await?;

    let user = match user {
        Some(user) => user,
        None => {
            return Err(Error::Unauthorized(
                UnauthorizedType::WrongUsernameOrPassword,
            ))
        }
    };

    if verify_password(&auth.password, &user.password) {
        let session = generate_session(&db, user.id).await?;

        let roles = role::Entity::find()
            .join(
                migration::JoinType::InnerJoin,
                role::Relation::UserRole
                    .def()
                    .on_condition(move |_left, right| {
                        Expr::tbl(right, user_role::Column::UserId)
                            .eq(user.id)
                            .into_condition()
                    }),
            )
            .all(&db)
            .await?;

        let roles = roles
            .into_iter()
            .map(|it| RoleResponse {
                id: it.id,
                name: it.name,
            })
            .collect::<Vec<_>>();

        Ok(JsonSuccess(LoginResponse { session, roles }))
    } else {
        Err(Error::Unauthorized(
            UnauthorizedType::WrongUsernameOrPassword,
        ))
    }
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct RoleRequest {
    pub id: i32,
}

#[derive(Debug, Serialize, Deserialize, Validate, Clone)]
pub struct RegisterRequest {
    #[validate(email)]
    pub email: String,
    #[validate(length(min = 8, max = 64))]
    pub password: String,

    pub roles: Vec<RoleRequest>,
}

pub async fn register(
    Extension(db): Extension<DatabaseConnection>,
    Json(auth): Json<RegisterRequest>,
) -> Result<JsonSuccess<LoginResponse>, Error> {
    auth.validate()?;

    let count = user::Entity::find()
        .filter(user::Column::Email.eq(auth.email.clone()))
        .count(&db)
        .await?;

    if count > 0 {
        return Err(Error::MustUniqueError("email".to_string()));
    }

    let uuid = Uuid::new_v4();

    let user = user::ActiveModel {
        id: ActiveValue::Set(uuid),
        email: ActiveValue::Set(auth.email),
        password: ActiveValue::Set(hash_password(&auth.password)?),
    };

    let roles = role::Entity::find()
        .filter(role::Column::Id.is_in(auth.roles.into_iter().map(|it| it.id)))
        .all(&db)
        .await?;

    db.transaction::<_, (), sea_orm::DbErr>(|db| {
        Box::pin(async move {
            user::Entity::insert(user.clone()).exec(db).await?;

            if roles.len() > 0 {
                user_role::Entity::insert_many(
                    roles
                        .into_iter()
                        .map(|it| user_role::ActiveModel {
                            user_id: user.id.clone(),
                            role_id: ActiveValue::Set(it.id),
                            id: Default::default(),
                        })
                        .collect::<Vec<_>>(),
                )
                .exec(db)
                .await
                .unwrap();
            }

            Ok(())
        })
    })
    .await?;

    let session = generate_session(&db, uuid).await?;

    Ok(JsonSuccess(LoginResponse {
        session,
        roles: vec![],
    }))
}

#[derive(Debug, Serialize, Deserialize, Validate, Clone)]
pub struct ChangePasswordRequest {
    old_password: String,
    new_password: String,
}

pub async fn change_password(
    Extension(db): Extension<DatabaseConnection>,
    user: crate::entity::user::Model,
    Json(request): Json<ChangePasswordRequest>,
) -> Result<JsonSuccess<()>, Error> {
    if !verify_password(&request.old_password, &user.password) {
        return Err(Error::Unauthorized(UnauthorizedType::WrongPassword));
    }

    let model = user::ActiveModel {
        id: ActiveValue::Set(user.id),
        password: ActiveValue::Set(hash_password(&request.new_password)?),
        ..Default::default()
    };
    user::Entity::update(model).exec(&db).await?;

    Ok(JsonSuccess(()))
}

fn verify_password(password: &str, hashed: &str) -> bool {
    let argon = Argon2::default();

    let hashed = match PasswordHash::new(hashed) {
        Ok(hashed) => hashed,
        Err(_) => return false,
    };

    argon.verify_password(password.as_bytes(), &hashed).is_ok()
}

fn hash_password(password: &str) -> Result<String, Error> {
    let argon = Argon2::default();
    let salt = SaltString::generate(&mut OsRng);

    argon
        .hash_password(password.as_bytes(), &salt)
        .map(|it| it.to_string())
        .map_err(Into::into)
}

