pub use sea_orm_migration::prelude::*;

mod m20221126_154332_create_user_table;
mod m20221126_155600_create_session_table;
mod m20221126_172825_create_role_table;
mod m20221126_172838_create_user_role_table;

pub struct Migrator;

#[async_trait::async_trait]
impl MigratorTrait for Migrator {
    fn migrations() -> Vec<Box<dyn MigrationTrait>> {
        vec![
            Box::new(m20221126_154332_create_user_table::Migration),
            Box::new(m20221126_155600_create_session_table::Migration),
            Box::new(m20221126_172825_create_role_table::Migration),
            Box::new(m20221126_172838_create_user_role_table::Migration),
        ]
    }
}
