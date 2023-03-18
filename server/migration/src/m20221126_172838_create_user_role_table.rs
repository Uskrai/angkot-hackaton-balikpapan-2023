use sea_orm_migration::prelude::*;

#[derive(DeriveMigrationName)]
pub struct Migration;

#[async_trait::async_trait]
impl MigrationTrait for Migration {
    async fn up(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .create_table(
                Table::create()
                    .table(UserRole::Table)
                    .if_not_exists()
                    .col(
                        ColumnDef::new(UserRole::Id)
                            .integer()
                            .not_null()
                            .auto_increment()
                            .primary_key(),
                    )
                    .col(ColumnDef::new(UserRole::UserId).uuid().not_null())
                    .col(ColumnDef::new(UserRole::RoleId).integer().not_null())
                    .foreign_key(
                        ForeignKey::create()
                            .to(User::Table, User::Id)
                            .from(UserRole::Table, UserRole::UserId),
                    )
                    .foreign_key(
                        ForeignKey::create()
                            .to(Role::Table, Role::Id)
                            .from(UserRole::Table, UserRole::RoleId),
                    )
                    .to_owned(),
            )
            .await
    }

    async fn down(&self, manager: &SchemaManager) -> Result<(), DbErr> {
        manager
            .drop_table(Table::drop().table(UserRole::Table).to_owned())
            .await
    }
}

/// Learn more at https://docs.rs/sea-query#iden
#[derive(Iden)]
enum UserRole {
    Table,
    Id,
    UserId,
    RoleId,
}

#[derive(Iden)]
enum User {
    Table,
    Id,
}

#[derive(Iden)]
enum Role {
    Table,
    Id,
}
