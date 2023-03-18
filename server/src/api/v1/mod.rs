pub mod auth;
pub mod role;

#[derive(serde::Serialize, serde::Deserialize, Debug)]
pub struct JsonSuccess<T>(pub T);

#[derive(serde::Serialize, serde::Deserialize, Debug)]
pub struct JsonFlattenSuccess<T>(pub T);

impl<T> axum::response::IntoResponse for JsonFlattenSuccess<T>
where
    T: serde::Serialize,
{
    fn into_response(self) -> axum::response::Response {
        #[derive(serde::Deserialize, serde::Serialize)]
        pub struct Inner<T> {
            #[serde(flatten)]
            data: T,
            status: &'static str,
        }
        axum::Json(Inner {
            data: self.0,
            status: "ok",
        })
        .into_response()
    }
}

impl<T> axum::response::IntoResponse for JsonSuccess<T>
where
    T: serde::Serialize,
{
    fn into_response(self) -> axum::response::Response {
        #[derive(serde::Deserialize, serde::Serialize)]
        pub struct Inner<T> {
            data: T,
            status: &'static str,
        }

        axum::Json(Inner {
            data: self.0,
            status: "ok",
        })
        .into_response()
    }
}

#[axum::async_trait]
impl<T, B, S> axum::extract::FromRequest<S, B> for JsonSuccess<T>
where
    T: serde::de::DeserializeOwned,
    B: axum::body::HttpBody + Send + 'static,
    B::Data: Send,
    B::Error: Into<axum::BoxError>,
    S: Send + Sync,
{
    type Rejection = axum::extract::rejection::JsonRejection;
    async fn from_request(
        req: axum::http::request::Request<B>,
        s: &S,
    ) -> Result<Self, Self::Rejection> {
        Ok(Self(axum::Json::from_request(req, s).await?.0))
    }
}

#[cfg(test)]
mod tests {
    use axum::{Json, extract::State};
    use migration::MigratorTrait;
    use sea_orm::{Database, DatabaseConnection, EntityTrait};

    use crate::{entity::role, session::Session, user::UserUuid};

    use super::{auth::RoleRequest, JsonSuccess};

    #[allow(dead_code)]
    pub struct Bootstrap {
        user_model: crate::entity::user::Model,
        user_password: String,
        session: Session,
        connection: DatabaseConnection,
    }

    impl Bootstrap {
        pub fn db(&self) -> State<DatabaseConnection> {
            State(self.connection.clone())
        }

        pub fn uuid(&self) -> UserUuid {
            UserUuid(self.user_model.id)
        }

        pub async fn user_model(&self) -> crate::entity::user::Model {
            self.user_model.clone()
        }

        pub fn user_email(&self) -> String {
            self.user_model.email.clone()
        }

        pub fn user_password(&self) -> String {
            self.user_password.clone()
        }

        pub async fn derive(&self, email: &str, password: &str) -> Bootstrap {
            let (user, session) = create_user(&self.connection, email, password).await;

            Bootstrap {
                user_model: user,
                user_password: password.to_string(),
                session,
                connection: self.connection.clone(),
            }
        }

        pub fn connection(&self) -> &DatabaseConnection {
            &self.connection
        }
    }

    pub async fn connection() -> DatabaseConnection {
        let db = Database::connect("sqlite::memory:").await.unwrap();
        migration::Migrator::up(&db, None).await.unwrap();
        db
    }

    pub async fn create_user(
        db: &DatabaseConnection,
        email: &str,
        password: &str,
    ) -> (crate::entity::user::Model, Session) {
        let roles = role::Entity::find()
            .all(db)
            .await
            .unwrap()
            .into_iter()
            .map(|it| RoleRequest { id: it.id })
            .collect();

        let JsonSuccess(user) = super::auth::register(
            State(db.clone()),
            Json(super::auth::RegisterRequest {
                email: email.to_string(),
                password: password.to_string(),
                roles,
            }),
        )
        .await
        .unwrap();

        let session = crate::session::Session {
            bearer: axum_auth::AuthBearer(user.session),
        };

        let user = crate::entity::user::Model::from_session(db, session.clone())
            .await
            .unwrap();

        (user, session)
    }

    pub async fn bootstrap() -> Bootstrap {
        let db = connection().await;
        let password = "password";
        let (user, session) = create_user(&db, "example@example.com", password).await;

        Bootstrap {
            connection: db,
            user_model: user,
            user_password: password.to_string(),
            session,
        }
    }
}
