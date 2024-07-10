#!/usr/bin/env bash

SPM_HOME="$HOME/.spm"
SPM_RECORD="$SPM_HOME/record"
SPM_BIN="$SPM_HOME/bin"
SPM_EXECUTABLE="$SPM_BIN/spm"
SPM_EXECUTABLE_URI="https://raw.githubusercontent.com/barnett617/shell-path-manager/master/bin/spm"

# Get the default shell
default_shell=$(basename "$SHELL")

# Check if the default shell is Zsh
if [[ "$default_shell" != "zsh" ]]; then
  echo "Error: Oh My Zsh can't be loaded from: $default_shell. You need to run Zsh instead."
  exit 1
fi

# Create the .spm directory if it doesn't exist
if [ ! -d "$SPM_HOME" ]; then
  mkdir "$SPM_HOME"
  echo "Created directory: $SPM_HOME"
else
  echo "Directory already exists: $SPM_HOME"
fi

# Create the record file inside .spm if it doesn't exist
if [ ! -f "$SPM_RECORD" ]; then
  touch "$SPM_RECORD"
  echo "Created file: $SPM_RECORD"
else
  echo "File already exists: $SPM_RECORD"
fi

# Create the bin directory inside .spm if it doesn't exist
if [ ! -d "$SPM_BIN" ]; then
  mkdir "$SPM_BIN"
  echo "Created directory: $SPM_BIN"
else
  echo "Directory already exists: $SPM_BIN"
fi

# Check if the file exist
spm_has() {
  type "$1" > /dev/null 2>&1
}

# Download helper
spm_download() {
  if spm_has "curl"; then
    curl --fail --compressed -q "$@"
  fi
}

# Download the binary file from github
spm_download -s "$SPM_EXECUTABLE" -o $SPM_EXECUTABLE_URI || {
  { echo "Failed to download spm executable"; exit 1; }
}
chmod +x "$SPM_EXECUTABLE" ||
  { echo "Failed to set permissions on spm executable"; exit 1; }
echo "Downloaded binary file: $SPM_EXECUTABLE"

# Add the bin directory to PATH and update it immediately
if [ -d "$SPM_BIN" ]; then
  case ":$PATH:" in
    *":$SPM_BIN:"*)
      echo "The bin directory is already in PATH"
      ;;
    *)
      echo "export PATH=\"$SPM_BIN:\$PATH\"" >> "$HOME/.zshrc"
      source "$HOME/.zshrc"
      echo "spm is ready to use"
      ;;
  esac
fi