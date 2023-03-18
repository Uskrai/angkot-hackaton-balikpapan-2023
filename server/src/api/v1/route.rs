use axum::extract::State;
use axum::Json;
use sea_orm::prelude::*;
use sea_orm::DatabaseConnection;
use sea_orm::IntoActiveModel;
use serde::Deserialize;
use serde::Serialize;

use crate::error::Error;
use crate::geo::Location;
use crate::PathUuid;

#[derive(Serialize, Deserialize)]
pub struct IndexResponse {
    routes: Vec<RouteResponse>,
}

#[derive(Serialize, Deserialize)]
pub struct RouteResponse {
    pub id: Uuid,
    pub name: String,
    pub lines: Vec<Location>,
    pub r#type: VehicleType,
}

#[derive(Serialize, Deserialize)]
pub struct LinesContent {
    lines: Vec<Location>,
}

#[derive(Serialize, Deserialize)]
pub enum VehicleType {
    Bus,
    SharedTaxi,
}

impl RouteResponse {
    pub fn from_model(model: crate::entity::route::Model) -> Result<Self, serde_json::Error> {
        Ok(Self {
            id: model.id,
            name: model.name,
            lines: serde_json::from_value::<LinesContent>(model.lines)?.lines,
            // route: model.route,
            r#type: VehicleType::from_model(model.vehicle_type),
        })
    }
}

impl VehicleType {
    pub fn from_model(model: crate::entity::sea_orm_active_enums::VehicleType) -> Self {
        match model {
            crate::entity::sea_orm_active_enums::VehicleType::Bus => Self::Bus,
            crate::entity::sea_orm_active_enums::VehicleType::SharedTaxi => Self::SharedTaxi,
        }
    }

    pub fn into_model(self) -> crate::entity::sea_orm_active_enums::VehicleType {
        match self {
            VehicleType::Bus => crate::entity::sea_orm_active_enums::VehicleType::Bus,
            VehicleType::SharedTaxi => crate::entity::sea_orm_active_enums::VehicleType::SharedTaxi,
        }
    }
}

pub async fn index(State(db): State<DatabaseConnection>) -> Result<Json<IndexResponse>, Error> {
    let models = crate::entity::route::Entity::find().all(&db).await?;

    let mut routes = vec![];
    for it in models {
        routes.push(RouteResponse::from_model(it)?)
    }

    Ok(Json(IndexResponse { routes }))
}

#[derive(Serialize, Deserialize)]
pub struct CreateRequest {
    pub name: String,
    pub lines: Vec<Location>,
    pub r#type: VehicleType,
}

pub async fn create(
    State(db): State<DatabaseConnection>,
    Json(request): Json<CreateRequest>,
) -> Result<Json<RouteResponse>, Error> {
    let model = crate::entity::route::Model {
        id: Uuid::new_v4(),
        name: request.name,
        vehicle_type: request.r#type.into_model(),
        lines: serde_json::to_value(LinesContent {
            lines: request.lines,
        })?,
    };

    crate::entity::route::Entity::insert(model.clone().into_active_model())
        .exec_without_returning(&db)
        .await?;

    Ok(Json(RouteResponse::from_model(model)?))
}

pub async fn delete(
    State(db): State<DatabaseConnection>,
    PathUuid(id): PathUuid,
) -> Result<(), Error> {
    crate::entity::route::Entity::delete_by_id(id)
        .exec(&db)
        .await?;

    Ok(())
}

pub async fn exists(db: &DatabaseConnection, id: Uuid, r#type: VehicleType) -> Result<bool, Error> {
    crate::entity::route::Entity::find_by_id(id)
        .filter(crate::entity::route::Column::VehicleType.eq(r#type.into_model()))
        .count(db)
        .await
        .map(|it| it != 0)
        .map_err(Into::into)
}
