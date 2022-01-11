{ pkgs }:

# Credits : https://github.com/maximbaz/dotfiles/blob/master/.local/bin/sway-autoname-workspaces
pkgs.writers.writePython3Bin "sway-auto-rename"

{
    libraries = [ pkgs.python3Packages.i3ipc ];
    flakeIgnore = ["E501" "W605"];
}

''
import argparse
import logging
import re
import signal
import sys

import i3ipc

WINDOW_ICONS = {
    "alacritty": "",
    "emacs": "Emacs",
    "thunar": "",
    "org.keepassxc.keepassxc": "",
    "bleachbit": "",
    "calibre": "",
    "chromium": "",
    "chromium-browser": "",
    "code-oss": "",
    "draw.io": "",
    "firefox": "",
    "gcr-prompter": "",
    "kitty": "",
    "org.ksnip.ksnip": "",
    "krita": "",
    "libreoffice-writer": "",
    "libreoffice-calc": "",
    "microsoft teams - preview": "",
    "mpv": "",
    "neomutt": "",
    "xplr": "",
    "paperwork": "",
    "pavucontrol": "",
    "peek": "",
    "qutepreview": "",
    "org.qutebrowser.qutebrowser": "",
    "riot": "",
    "signal": "",
    "slack": "",
    "spotify": "",
    "transmission-gtk": "",
    "vimiv": "",
    "virt-manager": "",
    "wofi": "",
    "org.pwmt.zathura": "",
}

DEFAULT_ICON = "󰀏"


def icon_for_window(window):
    name = None
    if window.app_id is not None and len(window.app_id) > 0:
        name = window.app_id.lower()
    elif window.window_class is not None and len(window.window_class) > 0:
        name = window.window_class.lower()

    if name in WINDOW_ICONS:
        return WINDOW_ICONS[name]

    logging.info("No icon available for window with name: %s" % str(name))
    return DEFAULT_ICON


def rename_workspaces(ipc):
    for workspace in ipc.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        icon_tuple = ()
        for w in workspace:
            if w.app_id is not None or w.window_class is not None:
                icon = icon_for_window(w)
                if not ARGUMENTS.duplicates and icon in icon_tuple:
                    continue
                icon_tuple += (icon,)
        name_parts["icons"] = " ".join(icon_tuple)
        new_name = construct_workspace_name(name_parts)
        ipc.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))


def undo_window_renaming(ipc):
    for workspace in ipc.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        name_parts["icons"] = None
        new_name = construct_workspace_name(name_parts)
        ipc.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))
    ipc.main_quit()
    sys.exit(0)


def parse_workspace_name(name):
    return re.match(
        "(?P<num>[0-9]+):?(?P<shortname>\w+)? ?(?P<icons>.+)?", name
    ).groupdict()


def construct_workspace_name(parts):
    new_name = str(parts["num"])
    if parts["shortname"] or parts["icons"]:
        new_name += ":"

        if parts["shortname"]:
            new_name += parts["shortname"]

        if parts["icons"]:
            new_name += " " + parts["icons"]

    return new_name


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="This script automatically changes the workspace name in sway depending on your open applications."
    )
    parser.add_argument(
        "--duplicates",
        "-d",
        action="store_true",
        help="Set it when you want an icon for each instance of the same application per workspace.",
    )
    parser.add_argument(
        "--logfile",
        "-l",
        type=str,
        default="/tmp/sway-autoname-workspaces.log",
        help="Path for the logfile.",
    )
    args = parser.parse_args()
    global ARGUMENTS
    ARGUMENTS = args

    logging.basicConfig(
        level=logging.INFO,
        filename=ARGUMENTS.logfile,
        filemode="w",
        format="%(message)s",
    )

    ipc = i3ipc.Connection()

    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: undo_window_renaming(ipc))

    def window_event_handler(ipc, e):
        if e.change in ["new", "close", "move"]:
            rename_workspaces(ipc)

    ipc.on("window", window_event_handler)

    rename_workspaces(ipc)

    ipc.main()
''
