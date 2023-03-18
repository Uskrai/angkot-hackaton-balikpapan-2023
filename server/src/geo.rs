use axum::extract::{ws::WebSocket, State};
use futures::stream::SplitSink;
use futures::{SinkExt, StreamExt};
use parking_lot::Mutex;
use sea_orm::DatabaseConnection;
use serde::de::DeserializeOwned;
use std::collections::HashSet;
use std::ops::Deref;
use std::sync::atomic::AtomicUsize;
use std::{collections::HashMap, sync::Arc};
use uuid::Uuid;

use axum::{extract::ws::Message as WSMessage, response::IntoResponse};
use serde::{Deserialize, Serialize};
use tokio::sync::broadcast::Sender;

use crate::api::v1::route::VehicleType;
use crate::error::Error;
use crate::PathUuid;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct Location {
    latitude: f64,
    longitude: f64,
}

impl From<Location> for geoutils::Location {
    fn from(v: Location) -> Self {
        Self::new(v.latitude, v.longitude)
    }
}

#[derive(Deserialize, Serialize, Clone, Debug)]
pub struct SharedTaxi {
    email: String,
    location: Location,
}

impl SharedTaxi {
    pub fn should_send(&self, user: &User) -> bool {
        let userloc: geoutils::Location = user.location().into();
        let selfloc: geoutils::Location = self.location.clone().into();

        userloc
            .is_in_circle(&selfloc, geoutils::Distance::from_meters(1000))
            .unwrap_or(false)
    }
}

#[derive(Deserialize, Serialize, Clone, Debug)]
pub struct Customer {
    email: String,
    location: Location,
}

impl Customer {
    pub fn should_send(&self, user: &User) -> bool {
        let userloc: geoutils::Location = user.location().into();
        let selfloc: geoutils::Location = self.location.clone().into();

        userloc
            .is_in_circle(&selfloc, geoutils::Distance::from_meters(1000))
            .unwrap_or(false)
        // match user {
        //     User::Driver(_) => true,
        //     User::Customer(_) => false,
        // }
    }
}

#[derive(Deserialize, Serialize, Clone, Debug)]
pub struct Bus {
    email: String,
    location: Location,
}

impl Bus {
    pub fn should_send(&self, user: &User) -> bool {
        let userloc: geoutils::Location = user.location().into();
        let selfloc: geoutils::Location = self.location.clone().into();

        userloc
            .is_in_circle(&selfloc, geoutils::Distance::from_meters(1000))
            .unwrap_or(false)
    }
}

#[derive(Serialize, Clone, Debug)]
pub enum User {
    Customer(Customer),
    SharedTaxi(SharedTaxi),
    Bus(Bus),
}

#[derive(Serialize, Clone, Debug)]
pub enum IniitalMessage {
    Customer(Customer),
    SharedTaxi(SharedTaxi),
    Bus(Bus),
}

impl From<SharedTaxi> for User {
    fn from(v: SharedTaxi) -> Self {
        Self::SharedTaxi(v)
    }
}

impl From<Customer> for User {
    fn from(v: Customer) -> Self {
        Self::Customer(v)
    }
}

impl From<Bus> for User {
    fn from(v: Bus) -> Self {
        Self::Bus(v)
    }
}

impl User {
    pub fn location(&self) -> Location {
        match self {
            User::SharedTaxi(it) => it.location.clone(),
            User::Customer(it) => it.location.clone(),
            User::Bus(it) => it.location.clone(),
        }
    }

    pub fn set_location(&mut self, location: Location) {
        match self {
            User::SharedTaxi(it) => it.location = location,
            User::Customer(it) => it.location = location,
            User::Bus(it) => it.location = location,
        }
    }

    pub fn should_send(&self, user: &User) -> bool {
        match self {
            User::SharedTaxi(it) => it.should_send(user),
            User::Customer(it) => it.should_send(user),
            User::Bus(it) => it.should_send(user),
        }
    }
}

// message that is send by all handler
#[derive(Debug, Clone)]
pub enum StateMessage {
    NewUser(String),
    UpdateLocation(String),
    CloseUser(String),
    PickupRequest {
        requester_id: String,
        requested_id: String,
    },
    PickupResponse {
        requester_id: String,
        requested_id: String,
        accepted: bool,
    },
}

pub struct Inner {
    sender: Sender<StateMessage>,
    list: Mutex<HashMap<String, Option<User>>>,
    last_id: AtomicUsize,
}

impl Default for Inner {
    fn default() -> Self {
        let (sender, _) = tokio::sync::broadcast::channel(10);
        Self {
            sender,
            list: Default::default(),
            last_id: Default::default(),
        }
    }
}

#[derive(Clone, Default)]
pub struct RouteState(Arc<Inner>);

impl Deref for RouteState {
    type Target = Arc<Inner>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

#[derive(Default)]
pub struct GeoStateInner {
    shared_taxi: Mutex<HashMap<Uuid, RouteState>>,
    bus: Mutex<HashMap<Uuid, RouteState>>,
}

#[derive(Default, Clone)]
pub struct GeoState(Arc<GeoStateInner>);

impl GeoState {
    async fn get(
        item: &Mutex<HashMap<Uuid, RouteState>>,
        db: &DatabaseConnection,
        id: Uuid,
        r#type: VehicleType,
    ) -> Result<RouteState, Error> {
        let state = item.lock().get(&id).cloned();

        if let Some(it) = state {
            return Ok(it);
        }

        if !super::api::v1::route::exists(db, id, r#type).await? {
            return Err(Error::NoResource);
        }

        Ok(item.lock().entry(id).or_default().clone())
    }

    pub async fn get_shared_taxi(
        &self,
        db: &DatabaseConnection,
        id: Uuid,
    ) -> Result<RouteState, crate::error::Error> {
        Self::get(&self.0.shared_taxi, db, id, VehicleType::SharedTaxi).await
    }

    pub async fn get_bus(
        &self,
        db: &DatabaseConnection,
        id: Uuid,
    ) -> Result<RouteState, crate::error::Error> {
        Self::get(&self.0.bus, db, id, VehicleType::Bus).await
    }
}

impl RouteState {
    pub fn insert_user(&self, user: Option<User>) -> String {
        let mut guard = self.0.list.lock();
        loop {
            let id = self
                .0
                .last_id
                .fetch_add(1, std::sync::atomic::Ordering::Relaxed)
                .to_string();
            // let id = nanoid::nanoid!();
            if !guard.contains_key(&id) {
                guard.insert(id.clone(), user);
                break id;
            }
        }
    }
}

#[derive(Deserialize, Clone, Debug)]
pub struct InitialCustomer {
    location: Location,
}

impl From<(crate::user::User, InitialCustomer)> for User {
    fn from(value: (crate::user::User, InitialCustomer)) -> Self {
        User::Customer(Customer {
            email: value.0.email,
            location: value.1.location,
        })
    }
}

pub async fn customer_shared_taxi(
    PathUuid(name): PathUuid,
    ws: axum::extract::ws::WebSocketUpgrade,
    State(state): State<GeoState>,
    State(db): State<DatabaseConnection>,
    user: crate::user::User,
) -> Result<impl IntoResponse, Error> {
    let state = state.get_shared_taxi(&db, name).await?;
    Ok(ws.on_upgrade(move |ws| async move {
        handle_websocket::<InitialCustomer>(state, ws, user).await
    }))
}

#[derive(Deserialize, Clone, Debug)]
pub struct InitialSharedTaxi {
    location: Location,
}

impl From<(crate::user::User, InitialSharedTaxi)> for User {
    fn from(value: (crate::user::User, InitialSharedTaxi)) -> Self {
        User::SharedTaxi(SharedTaxi {
            email: value.0.email,
            location: value.1.location,
        })
    }
}

pub async fn shared_taxi(
    PathUuid(name): PathUuid,
    ws: axum::extract::ws::WebSocketUpgrade,
    State(state): State<GeoState>,
    State(db): State<DatabaseConnection>,
    user: crate::user::User,
) -> Result<impl IntoResponse, Error> {
    let state = state.get_shared_taxi(&db, name).await?;
    Ok(ws.on_upgrade(move |ws| async move {
        handle_websocket::<InitialSharedTaxi>(state, ws, user).await
    }))
}

pub async fn customer_bus(
    PathUuid(name): PathUuid,
    ws: axum::extract::ws::WebSocketUpgrade,
    State(state): State<GeoState>,
    State(db): State<DatabaseConnection>,
    user: crate::user::User,
) -> Result<impl IntoResponse, Error> {
    let state = state.get_bus(&db, name).await?;
    Ok(ws.on_upgrade(move |ws| async move {
        handle_websocket::<InitialCustomer>(state, ws, user).await
    }))
}

#[derive(Deserialize, Clone, Debug)]
pub struct InitialBus {
    location: Location,
}

impl From<(crate::user::User, InitialBus)> for User {
    fn from(value: (crate::user::User, InitialBus)) -> Self {
        User::Bus(Bus {
            email: value.0.email,
            location: value.1.location,
        })
    }
}

pub async fn bus(
    PathUuid(name): PathUuid,
    ws: axum::extract::ws::WebSocketUpgrade,
    State(state): State<GeoState>,
    State(db): State<DatabaseConnection>,
    user: crate::user::User,
) -> Result<impl IntoResponse, Error> {
    let state = state.get_bus(&db, name).await?;
    Ok(ws
        .on_upgrade(move |ws| async move { handle_websocket::<InitialBus>(state, ws, user).await }))
}

#[derive(Debug)]
pub enum DMessage {
    // message that is send by other handler
    StateMessage(StateMessage),
    // message that is send by client
    WSMessage(WSMessage),
}

#[derive(Serialize, Deserialize)]
pub struct UpdateLocation {
    location: Location,
}

// PickupRequest flow:
// User send MessageFromUser::PickupRequest with requested user as parameter.
// then server send MessageToUser::PickupRequest to the requested user with the requester id as parameter
// if the requested user accept, then requested user will send back MessageFromUser::PickupResponse with
// accepted true, then server will send MessageToUser::PickupResponse back to requester user with accepted: true
// if the requested user reject, then requested user will send back MessageFromUser::PickupResponse with
// accepted false, then server will send MessageToUser::PickupResponse back to requester user with accepted: false

// message that user receive
#[derive(Serialize, Debug)]
pub enum MessageToUser {
    NewUser { id: String, user: User },
    UpdateLocation { id: String, location: Location },
    RemoveUser { id: String },

    PickupRequest { id: String },
    PickupResponse { id: String, accepted: bool },
}

// message that user send
#[derive(Deserialize)]
pub enum MessageFromUser<U> {
    InitialMessage(U),
    UpdateLocation { location: Location },

    PickupRequest { id: String },
    PickupResponse { id: String, accept: bool },
}

pub struct UserState {
    id: String,
    state: RouteState,
    sink: SplitSink<WebSocket, WSMessage>,
    users: HashSet<String>,
}

impl UserState {
    fn should_send_id(&self, id: &String) -> Option<User> {
        let users = self.state.0.list.lock();
        let user = users.get(id).map(|it| it.as_ref()).flatten();
        let current = users.get(&self.id).map(|it| it.as_ref()).flatten();

        if let (Some(current), Some(user)) = (current, user) {
            if current.should_send(&user) {
                Some(user.clone())
            } else {
                None
            }
        } else {
            None
        }
    }

    async fn send_force(&mut self, msg: MessageToUser) -> Result<(), axum::Error> {
        tracing::trace!("sending to {} {:?}", self.id, msg);
        let it = match serde_json::to_string(&msg) {
            Ok(it) => it,
            Err(err) => {
                tracing::error!("{}", err);
                return Ok(());
            }
        };

        self.sink.send(WSMessage::Text(it)).await
    }

    pub async fn send_message(&mut self, message: StateMessage) -> bool {
        match message {
            StateMessage::NewUser(new_id) => {
                if new_id == self.id {
                    return true;
                }

                if let Some(user) = self.should_send_id(&new_id) {
                    tracing::trace!("insert {new_id} in {}", self.id);
                    self.users.insert(new_id.clone());

                    self.send_force(MessageToUser::NewUser { id: new_id, user })
                        .await
                        .ok();
                }
            }
            StateMessage::UpdateLocation(new_id) => {
                if new_id == self.id {
                    return true;
                }

                if self.users.contains(&new_id) {
                    if let Some(user) = self.should_send_id(&new_id) {
                        self.send_force(MessageToUser::UpdateLocation {
                            id: new_id,
                            location: user.location().clone(),
                        })
                        .await
                        .ok();
                    } else {
                        tracing::trace!("remove {new_id} in {}", self.id);
                        self.users.remove(&new_id);

                        self.send_force(MessageToUser::RemoveUser { id: new_id })
                            .await
                            .ok();
                    }
                } else {
                    if let Some(user) = self.should_send_id(&new_id) {
                        tracing::trace!("insert {new_id} in {}", self.id);
                        self.users.insert(new_id.to_string());

                        self.send_force(MessageToUser::NewUser { id: new_id, user })
                            .await
                            .ok();
                    }
                }
            }
            StateMessage::PickupRequest {
                requester_id,
                requested_id,
            } => {
                if self.id != requested_id {
                    return false;
                }

                self.send_force(MessageToUser::PickupRequest { id: requester_id })
                    .await
                    .ok();
            }
            StateMessage::PickupResponse {
                requested_id,
                requester_id,
                accepted,
            } => {
                if self.id != requester_id {
                    return false;
                }

                self.send_force(MessageToUser::PickupResponse {
                    id: requested_id,
                    accepted,
                })
                .await
                .ok();
            }
            StateMessage::CloseUser(new_id) => {
                if new_id == self.id {
                    return false;
                }

                if self.users.contains(&new_id) {
                    tracing::trace!("remove {new_id} in {}", self.id);
                    self.users.remove(&new_id);

                    self.send_force(MessageToUser::RemoveUser { id: new_id })
                        .await
                        .ok();
                }
            }
        };

        true
    }
}

async fn handle_websocket<U>(state: RouteState, ws: WebSocket, user_model: crate::user::User)
where
    U: DeserializeOwned,
    (crate::user::User, U): Into<User>,
{
    let current_id = state.insert_user(None);
    tracing::debug!("new user {current_id}");

    let (tx, rx) = async_channel::unbounded();
    let (wsender, mut wrecv) = ws.split();

    let mut userstate = UserState {
        id: current_id.to_string(),
        sink: wsender,
        state: state.clone(),
        users: Default::default(),
    };

    let state_receiver = async {
        let mut receiver = state.sender.subscribe();

        while let Ok(it) = receiver.recv().await {
            if tx.send(DMessage::StateMessage(it)).await.is_err() {
                break;
            }
        }
    };

    let state_sender = state.0.sender.clone();

    let close_user = || {
        state.0.list.lock().remove(&current_id);
        state_sender
            .send(StateMessage::CloseUser(current_id.clone()))
            .ok();
        tracing::info!("closing user {current_id}");
    };

    let websocket_sender = async {
        while let Some(Ok(it)) = wrecv.next().await {
            if tx.send(DMessage::WSMessage(it)).await.is_err() {
                break;
            }
        }

        tracing::trace!("closing websocket {current_id}");
        close_user();
    };

    let channel_receiver = async {
        while let Ok(it) = rx.recv().await {
            tracing::trace!("received: {current_id} {it:?}");
            match it {
                DMessage::StateMessage(message) => {
                    if !userstate.send_message(message).await {
                        break;
                    }
                }
                DMessage::WSMessage(msg) => match msg {
                    WSMessage::Text(text) => {
                        let message: MessageFromUser<U> = match serde_json::from_str(&text) {
                            Ok(it) => it,
                            Err(err) => {
                                tracing::error!("{}", err);
                                continue;
                            }
                        };

                        let send_result = match message {
                            MessageFromUser::InitialMessage(request) => {
                                match state.0.list.lock().get_mut(&current_id) {
                                    Some(it) => {
                                        if it.is_some() {
                                            continue;
                                        }

                                        let user = (user_model.clone(), request).into();
                                        *it = Some(user);
                                        drop(it);
                                    }
                                    None => continue,
                                }

                                let users = state.0.list.lock().clone();
                                for (id, user) in users {
                                    if user.is_some() {
                                        userstate.send_message(StateMessage::NewUser(id)).await;
                                    }
                                }

                                Some(state_sender.send(StateMessage::NewUser(current_id.clone())))
                            }
                            MessageFromUser::UpdateLocation { location } => {
                                match state
                                    .list
                                    .lock()
                                    .get_mut(&current_id)
                                    .and_then(|it| it.as_mut())
                                {
                                    Some(it) => it.set_location(location),
                                    None => continue,
                                };

                                Some(
                                    state_sender
                                        .send(StateMessage::UpdateLocation(current_id.clone())),
                                )
                            }
                            MessageFromUser::PickupRequest { id } => {
                                match state.list.lock().get_mut(&id).and_then(|it| it.as_mut()) {
                                    Some(it) => {
                                        // only allow customer
                                        match it {
                                            User::Customer(_) => {}
                                            User::SharedTaxi(_) | User::Bus(_) => continue,
                                        }
                                    }
                                    None => continue,
                                }

                                Some(state_sender.send(StateMessage::PickupRequest {
                                    requester_id: current_id.clone(),
                                    requested_id: id,
                                }))
                            }
                            MessageFromUser::PickupResponse { id, accept } => {
                                match state.list.lock().get_mut(&id).and_then(|it| it.as_mut()) {
                                    Some(it) => {
                                        // only disallow customer
                                        match it {
                                            User::Customer(_) => continue,
                                            User::SharedTaxi(_) | User::Bus(_) => {}
                                        }
                                    }
                                    None => continue,
                                }

                                Some(state_sender.send(StateMessage::PickupResponse {
                                    requester_id: id,
                                    requested_id: current_id.clone(),
                                    accepted: accept,
                                }))
                            }
                        };

                        if let Some(Err(err)) = send_result {
                            tracing::error!("{}", err);
                        }
                    }
                    WSMessage::Close(_) => {
                        break;
                    }
                    _ => {}
                },
            }
        }
    };

    futures::join!(state_receiver, websocket_sender, channel_receiver);

    close_user();

    state.0.list.lock().remove(&current_id);
}
