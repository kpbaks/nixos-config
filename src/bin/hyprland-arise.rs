use clap::Parser;
use hyprland::data::{Client, Clients, Workspace};
use hyprland::dispatch::*;
use hyprland::prelude::*;
use log::debug;

#[derive(clap::Parser)]
#[clap(version, author, about)]
struct Cli {
    #[arg(short, long)]
    class: String,

    #[arg(long)]
    exec: Option<String>,
}

// #[derive(Debug, derive_more::Display)]
// enum AppError {
//     #[display(fmt = "no client found matching --class class")]
//     ClientNotFound,
// }

// impl std::error::Error for AppError {}

fn main() -> anyhow::Result<()> {
    env_logger::try_init()?;
    let cli = Cli::try_parse()?;

    let active_workspace = Workspace::get_active()?;
    debug!("active workspace: {:?}", active_workspace);

    let fullscreen = active_workspace.fullscreen;
    if fullscreen {
        hyprland::dispatch!(ToggleFullscreen, FullscreenType::Real)?;
    }

    Clients::get()?.for_each(|client| println!("{:#?}", client));

    // all open windows
    // let mut clients = Clients::get()?;

    let clients_matching_class = Clients::get()?
        .filter(|client| client.class.to_lowercase() == cli.class)
        .collect::<Vec<_>>();

    if clients_matching_class.is_empty() {
        let exec = cli.exec.unwrap_or(cli.class);
        // Spawn a new instance of the app
        hyprland::dispatch!(Exec, &exec)?;
    } else {
        let active_window = Client::get_active()?.expect("there is an active window");
        // Check if the active window is one of the clients matching the class.
        // If it is then bring to focus the window after it (wrapping around to zero, if at the last).
        // Otherwise just focus the first one.

        let pid = clients_matching_class
            .iter()
            .position(|client| client.pid == active_window.pid)
            .map(|index| {
                let next_index = (index + 1) % clients_matching_class.len();
                clients_matching_class[next_index].pid
            })
            .unwrap_or(clients_matching_class[0].pid);
        let window_identifier = WindowIdentifier::ProcessId(pid.try_into().unwrap());

        // let window_identifier = clients_matching_class.iter().position(|client| {
        //     client.pid == active_window.pid
        //
        // }).and_then
        // let window_identifier = if active_window.class.to_lowercase() == cli.class {
        //     let index = clients_matching_class
        //         .iter()
        //         .position(|client| client.pid == active_window.pid)
        //         .unwrap();
        //     let next_index = (index + 1) % clients_matching_class.len();
        //     WindowIdentifier::ProcessId(clients_matching_class[next_index].pid.try_into().unwrap())
        // } else {
        //     WindowIdentifier::ProcessId(clients_matching_class[0].pid.try_into().unwrap())
        // };

        // clients_matching_class.zip((0..clients_matching_class.len()))
        // let active_window_has_class = active_window.class.to_lowercase() == cli.class;
        //
        // let window_identifier = WindowIdentifier::ProcessId(client.pid.try_into().unwrap());
        // debug!("window identifier: {:?}", window_identifier);

        hyprland::dispatch!(
            MoveToWorkspace,
            WorkspaceIdentifierWithSpecial::Id(active_workspace.id),
            Some(window_identifier.clone())
        )?;

        hyprland::dispatch!(FocusWindow, window_identifier)?;
    }

    if fullscreen {
        hyprland::dispatch!(ToggleFullscreen, FullscreenType::Real)?;
    }

    // TODO: handle case with multiple clients matching
    // if let Some(client) = Clients::get()?.find(|client| client.class.to_lowercase() == cli.class) {

    // /// This dispatcher moves a window (focused if not specified) to a workspace
    // MoveToWorkspace(
    //     WorkspaceIdentifierWithSpecial<'a>,
    //     Option<WindowIdentifier<'a>>,
    // ),

    // hyprland::dispatch!(
    //     FocusWindow,
    //     WindowIdentifier::ProcessId(client.pid.try_into().unwrap())
    // )?;

    // hyprland::ctl::notify::call(
    //     Info,
    //     Duration::from_secs(2),
    //     Color::new(100, 0, 0, 128),
    //     "hello".into(),
    // )?;

    Ok(())
}
