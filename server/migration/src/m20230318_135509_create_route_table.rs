use sea_orm::{ActiveEnum, DeriveActiveEnum, EnumIter};
use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        let be = manager.get_database_backend();
        let schema = sea_orm::Schema::new(be);

        if let sea_orm::DatabaseBackend::Postgres = be {
            manager
                .create_type(schema.create_enum_from_active_enum::<VehicleType>())
                .await?;
        }

        manager
            .create_table(
                Table::create()
                    .table(Route::Table)
                    .if_not_exists()
                    .col(
                        ColumnDef::new(Route::Id)
                            .uuid()
                            .not_null()
                            .primary_key(),
                    )
                    .col(ColumnDef::new(Route::Name).string().not_null())
                    .col(
                        // VehicleType
                        ColumnDef::new_with_type(
                            Route::Vehicle,
                            <VehicleType as ActiveEnum>::db_type()
                                .get_column_type()
                                .clone(),
                        )
                        .not_null(),
                    )
                    .col(ColumnDef::new(Route::Lines).json().not_null())
                    .to_owned(),
            )
            .await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .drop_table(Table::drop().table(Route::Table).to_owned())
            .await
    }
}

// #[derive(DeriveEntityModel)]
// pub struct Route {
//     #[sea_orm(primary_key)]
//     pub id: Uuid,
//     pub name: String,
//     pub vehicle: VehicleType,
// }
//
/// Learn more at https://docs.rs/sea-query#iden
#[derive(Iden)]
enum Route {
    Table,
    Id,
    Name,
    Vehicle,
    Lines,
}

#[derive(EnumIter, DeriveActiveEnum, Iden)]
#[sea_orm(rs_type = "String", db_type = "Enum", enum_name = "vehicle_type")]
enum VehicleType {
    #[sea_orm(string_value = "Bus")]
    Bus,
    #[sea_orm(string_value = "SharedTaxi")]
    SharedTaxi,
}
