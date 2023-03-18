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

#[derive(Debug, Serialize, Deserialize)]
pub struct LoginResponse {
    pub roles: Vec<RoleResponse>,
    pub session: String,
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

