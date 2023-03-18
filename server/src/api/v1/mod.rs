pub mod auth;

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
impl<T, B> axum::extract::FromRequest<B> for JsonSuccess<T>
where
    T: serde::de::DeserializeOwned,
    B: axum::body::HttpBody + Send,
    B::Data: Send,
    B::Error: Into<axum::BoxError>,
{
    type Rejection = axum::extract::rejection::JsonRejection;
    async fn from_request(
        req: &mut axum::extract::RequestParts<B>,
    ) -> Result<Self, Self::Rejection> {
        Ok(Self(axum::Json::from_request(req).await?.0))
    }
}

