use axum::{
    extract::{FromRef, FromRequestParts, Path},
    RequestPartsExt,
};
use geo::GeoState;
use sea_orm::DatabaseConnection;
use uuid::Uuid;

pub mod api;
pub mod entity;
pub mod error;
pub mod geo;
pub mod session;
pub mod user;

#[derive(FromRef, Clone)]
pub struct AppState {
    pub connection: DatabaseConnection,
    pub geo: GeoState,
}

pub struct PathUuid(pub Uuid);

#[axum::async_trait]
impl<S> FromRequestParts<S> for PathUuid {
    type Rejection = error::Error;

    async fn from_request_parts(
        req: &mut axum::http::request::Parts,
        _s: &S,
    ) -> Result<Self, Self::Rejection> {
        let string = req.extract::<Path<String>>().await?;

        Ok(PathUuid(
            string.parse().map_err(|_| error::Error::NoResource)?,
        ))
    }
}
