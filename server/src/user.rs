use axum::{
    async_trait,
    extract::{FromRef, FromRequestParts, State},
    RequestPartsExt,
};
use sea_orm::{prelude::Uuid, DatabaseConnection, EntityTrait};
use serde::{Deserialize, Serialize};

use crate::{
    entity,
    error::{Error, UnauthorizedType},
    session::Session,
};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct User {
    pub id: Uuid,
    pub email: String,
}

#[async_trait]
impl<S> FromRequestParts<S> for User
where
    DatabaseConnection: FromRef<S>,
    S: Send + Sync,
{
    type Rejection = Error;

    async fn from_request_parts(
        req: &mut axum::http::request::Parts,
        _s: &S,
    ) -> Result<Self, Self::Rejection> {
        let State(db) = req
            .extract_with_state::<State<DatabaseConnection>, _>(_s)
            .await
            .unwrap();

        let session = req.extract::<Session>().await?;
        Self::from_session(&db, session).await
    }
}

#[async_trait]
impl<S> FromRequestParts<S> for crate::entity::user::Model
where
    DatabaseConnection: FromRef<S>,
    S: Send + Sync,
{
    type Rejection = Error;

    async fn from_request_parts(
        req: &mut axum::http::request::Parts,
        s: &S,
    ) -> Result<Self, Self::Rejection> {
        let db = DatabaseConnection::from_ref(s);

        let session = req.extract::<Session>().await?;
        Self::from_session(&db, session).await
    }
}

impl crate::entity::user::Model {
    pub async fn from_session(db: &DatabaseConnection, session: Session) -> Result<Self, Error> {
        let session = session.get_user_id(db).await?;

        let user = entity::user::Entity::find_by_id(session.user_id)
            .one(db)
            .await?;

        match user {
            Some(user) => Ok(user),
            None => Err(Error::Unauthorized(UnauthorizedType::InvalidSessionId)),
        }
    }
}

impl User {
    pub async fn from_session(db: &DatabaseConnection, session: Session) -> Result<Self, Error> {
        let user = crate::entity::user::Model::from_session(db, session).await?;

        Ok(User {
            id: user.id,
            email: user.email,
        })
    }
}

pub struct UserUuid(pub Uuid);

#[async_trait]
impl<S> FromRequestParts<S> for UserUuid
where
    DatabaseConnection: FromRef<S>,
    S: Send + Sync,
{
    type Rejection = Error;

    async fn from_request_parts(
        req: &mut axum::http::request::Parts,
        s: &S,
    ) -> Result<Self, Self::Rejection> {
        let db = DatabaseConnection::from_ref(s);

        let session = req.extract::<Session>().await?;

        let model = session.get_user_id(&db).await?;

        Ok(Self(model.user_id))
    }
}
