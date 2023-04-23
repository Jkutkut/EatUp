use warp::ws::{Message};
use warp::{Reply, Filter, Rejection, Error};
use tokio_stream::wrappers::UnboundedReceiverStream;
use futures::{FutureExt, StreamExt};
use tokio::sync::mpsc::{UnboundedSender, unbounded_channel};

use std::process::Command;

mod cmd;

async fn incoming_msg(
    socket: &UnboundedSender::<Result<Message, Error>>,
    msg: Message
) {
    println!("msg: {:?}", msg);
    let msg: String = match msg.to_str() {
        Ok(msg) => msg.to_string(),
        Err(e) => {
            println!("Not able to get msg string at incoming_msg: {:?}", e);
            return;
        }
    };
    
    let micro = cmd::get_microservice(msg).await;
    match micro {
        Ok(micro) => {
            println!("micro: {:?}", micro);
            socket.send(Ok(Message::text(format!("micro: {:?}", micro)))).unwrap();
        },
        Err(e) => {
            println!("error: {:?}", e);
            socket.send(Ok(Message::text(format!("error: {:?}", e)))).unwrap();
        }
    }
}

async fn ws_handler(ws: warp::ws::Ws) -> Result<impl Reply, Rejection> {
    Ok(ws.on_upgrade(move |socket| async {
        println!("Socket connection\n");
        let (client_ws_sender, mut client_ws_rcv) = socket.split();
        let (client_sender, client_rcv) = unbounded_channel();
        let client_rcv = UnboundedReceiverStream::new(client_rcv);
        tokio::task::spawn(client_rcv.forward(client_ws_sender).map(|result| {
            if let Err(e) = result {
                eprintln!("error sending websocket msg: {}", e);
            }
        }));
        while let Some(result) = client_ws_rcv.next().await {
            match result {
                Ok(msg) => incoming_msg(&client_sender, msg).await,
                Err(e) => {
                    eprintln!("error receiving ws message: {}", e);
                    break;
                }
            }
        }
        println!("socket disconnected\n");
    }))
}

#[tokio::main]
async fn main() {
    let port = 9000;
    let routes = warp::path("ws")
        .and(warp::ws())
        .and_then(ws_handler)
        .with(warp::cors().allow_any_origin());
    println!("Running on port {port}");
    warp::serve(routes).run(([0, 0, 0, 0], port)).await;
}
