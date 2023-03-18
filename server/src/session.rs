use axum::{async_trait, extract::FromRequest};
use sea_orm::{prelude::Uuid, ActiveValue, DatabaseConnection, EntityTrait};

use crate::{
    entity::{self, session},
    error::Error,
};

pub async fn generate_session(
    db: &DatabaseConnection,
    uuid: Uuid,
) -> Result<String, sea_orm::DbErr> {
    use rand::Rng;

    let rand_string: String = rand::thread_rng()
        .sample_iter(&rand::distributions::Alphanumeric)
        .take(255)
        .map(char::from)
        .collect();

    session::Entity::insert(session::ActiveModel {
        id: ActiveValue::Set(rand_string.clone()),
        user_id: ActiveValue::Set(uuid),
        payload: ActiveValue::Set(sea_orm::JsonValue::Object(Default::default())),
    })
    .exec(db)
    .await
    .map(|_| rand_string)
}
