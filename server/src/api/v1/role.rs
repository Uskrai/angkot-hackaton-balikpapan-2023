use axum::Extension;
use sea_orm::{DatabaseConnection, EntityTrait};
use serde::{Deserialize, Serialize};

use crate::{entity::role, error::Error};

use super::JsonSuccess;

#[derive(Debug, Serialize, Deserialize)]
pub struct Response {
    id: i32,
    name: String,
}

pub async fn index(
    Extension(db): Extension<DatabaseConnection>,
) -> Result<JsonSuccess<Vec<Response>>, Error> {
    let db = role::Entity::find().all(&db).await?;

    Ok(JsonSuccess(
        db.into_iter()
            .map(|it| Response {
                id: it.id,
                name: it.name,
            })
            .collect(),
    ))
}
