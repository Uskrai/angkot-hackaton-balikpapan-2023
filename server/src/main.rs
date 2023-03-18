mod entity;
use std::net::SocketAddr;

use axum::{Extension, Router};
use migration::MigratorTrait;
use sea_orm::{ConnectOptions, Database};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

mod api;
mod error;
mod session;
mod user;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    tracing_subscriber::registry()
        .with(tracing_subscriber::EnvFilter::new(
            std::env::var("RUST_LOG").unwrap_or_else(|_| "angkot=debug,tower_http=debug".into()),
        ))
        .with(tracing_subscriber::fmt::layer())
        .init();

    let mut opt =
        ConnectOptions::new(std::env::var("DATABASE_URL").expect("DATABASE_URL required"));
    opt.max_connections(10);

    let db = Database::connect(opt)
        .await
        .expect("cannot connect to database");

    migration::Migrator::up(&db, None).await.unwrap();

    let apiv1 = Router::new()
        .nest(
            "/auth",
            Router::new()
                .route("/login", axum::routing::post(api::v1::auth::login))
                .route("/register", axum::routing::post(api::v1::auth::register))
                .route("/profile", axum::routing::get(api::v1::auth::profile))
                .route(
                    "/changepassword",
                    axum::routing::post(api::v1::auth::change_password),
                ),
        );

    let app = Router::new()
        .nest("/api/v1", apiv1)
        .layer(Extension(db))
        .layer(tower_http::trace::TraceLayer::new_for_http());

    let addr = SocketAddr::from(([0, 0, 0, 0], 3000));
    tracing::debug!("listening on {}", addr);

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}
