use clap::Parser;
use hyprland::data::{Client, Clients, Monitors, Workspace};
use hyprland::dispatch::*;
use hyprland::prelude::*;

#[derive(clap::Parser)]
#[clap(version, author, about)]
struct Cli {
    #[arg(short, long)]
    class: String,

    #[arg(long)]
    exec: Option<String>,
}

#[derive(Debug, derive_more::Display)]
enum AppError {
    #[display(fmt = "no client found matching --class class")]
    ClientNotFound,
}

impl std::error::Error for AppError {}

fn main() -> anyhow::Result<()> {
    let cli = Cli::try_parse()?;

    let active_workspace = Workspace::get_active()?;

    // Clients::get()?.for_each(|client| println!("{:?}", client));

    // all open windows
    // let mut clients = Clients::get()?;

    // TODO: handle case with multiple clients matching
    if let Some(client) = Clients::get()?.find(|client| client.class.to_lowercase() == cli.class) {
        let window_identifier = WindowIdentifier::ProcessId(client.pid.try_into().unwrap());

        hyprland::dispatch!(
            MoveToWorkspace,
            WorkspaceIdentifierWithSpecial::Id(active_workspace.id),
            Some(window_identifier)
        )?;
    } else {
        // Spawn a new instance of the app
        hyprland::dispatch!(Exec, &cli.class)?;
    }

    // /// This dispatcher moves a window (focused if not specified) to a workspace
    // MoveToWorkspace(
    //     WorkspaceIdentifierWithSpecial<'a>,
    //     Option<WindowIdentifier<'a>>,
    // ),

    // hyprland::dispatch!(
    //     FocusWindow,
    //     WindowIdentifier::ProcessId(client.pid.try_into().unwrap())
    // )?;

    Ok(())
}
