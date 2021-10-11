{ pkgs }:

pkgs.writeShellScriptBin "sway-focus-or-open" ''
focus() {
  swaymsg "[app_id="$app_id"] focus" >/dev/null
}

open_or_run() {
  if pgrep -fa "$binary" >/dev/null; then
      # When the application is already running in the background, starting it
      # again will typically open the window and exit.
      $binary
  else
      # If the application is not running, start it but do not wait for it.
      $binary >/dev/null 2>/dev/null &
  fi
}

focus_wait() {
  # For applications that are slow to start, we try every 0.1s until their
  # window is open.
  for i in {1..30}; do
      if focus; then
          break
      fi
      sleep 0.1
  done
}

app_id=$1
binary=$2

focus || (
  open_or_run
  focus_wait
)
''
