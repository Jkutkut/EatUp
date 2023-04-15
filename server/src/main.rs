use rocket::{Build, Rocket, launch, routes, catchers, get};
use std::env;
use rocket::tokio;
use tokio_postgres::NoTls;
use std::net::Ipv4Addr;
use rocket::serde::json::Json;

mod api;
mod db;
mod tools;
mod qr;

use tools::route_error;

#[get("/")]
pub fn ping() -> Json<&'static str> {
    Json("Eatup up and running!")
}

#[launch]
async fn rocket() -> Rocket<Build> {
    dotenv::from_path("/db/.env").ok();
    let db_properties = format!(
        "host={} port={} dbname={} user={} password={}",
        env::var("DB_IP").unwrap(),
        env::var("DB_PORT").unwrap(),
        env::var("DB_NAME").unwrap(),
        env::var("DB_USER").unwrap(),
        env::var("DB_USER_PASSWD").unwrap(),
    );

    let (client, connection) = match tokio_postgres::connect(&db_properties, NoTls).await {
        Ok((client, connection)) => (client, connection),
        Err(e) => {
            eprintln!("Not able to connect with DB:\n{}", e);
            eprintln!("Is the DB running?");
            std::process::exit(1);
        }
    };
 
    // Create the thread that will handle the communication with the database
    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
            eprintln!("Stopping the server...");
            std::process::exit(1);
        }
    });

    let config = rocket::Config {
        address: Ipv4Addr::new(0, 0, 0, 0).into(),
        ..rocket::Config::debug_default()
    };
    rocket::custom(&config)
        .manage(client)
        .mount("/", routes![ping])
        .mount("/api/v1", api::get_v1_routes())
        .register("/api", catchers![route_error::api_not_implemented])
        .mount("/", rocket::fs::FileServer::from("/db/public"))
        .register("/qr/", catchers![route_error::qr_not_found, route_error::internal_server_error])
}