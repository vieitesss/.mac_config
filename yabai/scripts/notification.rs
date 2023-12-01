#!/usr/bin/env rustx

use clap::{Args, Parser, Subcommand};
use execute::Execute;
use std::process::{Command, Stdio};

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,

    #[arg(short, long, default_value = "Titulo")]
    ///Notification title
    title: String, 

    #[arg(short, long, default_value = "Message")]
    ///Notification title
    message: String,
}

#[derive(Subcommand)]
enum Commands {
    ///Notify current configuration
    Notify(NotifyArgs),
}

#[derive(Args)]
#[group(multiple = false, required = true)]
struct NotifyArgs {
    ///Space configuration
    #[arg(short, long)]
    space: bool,
}

struct Notification {
    title: Box<str>,
    message: Box<str>,
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Some(Commands::Notify(option)) => notify(option),
        None => {
            send_notification(Notification {
                title: cli.title.into(),
                message: cli.message.into(),
            })
        }
    };
}

fn notify(option: NotifyArgs) {
    if option.space {
        let mut command = Command::new("yabai");
        command.arg("-m").arg("query").arg("--spaces"); // Returns spaces information

        let mut command2 = Command::new("jq");
        command2.arg(".[] | select(.[\"has-focus\"]) | .type"); // Returns current space layout type

        let mut command3 = Command::new("sed");
        command3.arg("-e").arg("s/\"//g");

        // Captura la salida del comando en memoria en vez de mostrarla por pantalla
        command3.stdout(Stdio::piped());

        let output = command
            .execute_multiple_output(&mut [&mut command2, &mut command3])
            .unwrap();

        if let Some(exit_code) = output.status.code() {
            if exit_code == 0 {
                let space_layout: String =
                    String::from_utf8(output.stdout).unwrap().trim().to_string();

                let message = match space_layout.as_str() {
                    "bsp" => "Tiling mode",
                    "float" => "Floating mode",
                    _ => "Unknown space layout type",
                };

                send_notification(Notification {
                    title: "Space layout".into(),
                    message: message.into(),
                });
            } else {
                send_notification(Notification {
                    title: "Error".into(),
                    message: "Error executing the command".into(),
                })
            }
        } else {
            send_notification(Notification {
                title: "Interrupted!".into(),
                message: "The execution was interrupted".into(),
            })
        }
    }
}

fn send_notification(notification: Notification) {
    let mut command = Command::new("osascript");
    command.arg("-e").arg(format!(
        "display notification \"{}\" with title \"{}\"",
        notification.message, notification.title
    ));

    let output = command.execute_output().unwrap();

    if let Some(exit_code) = output.status.code() {
        if exit_code != 0 {
            eprintln!("Error sending the notification");
        }
    } else {
        eprintln!("The execution was interrupted");
    }
}
