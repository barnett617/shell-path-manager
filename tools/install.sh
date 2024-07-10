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

clear_spm() {
  rm -rf "$SPM_HOME"
}

# Download the binary file from github
download_executable() {
  local uri=$1
  local executable=$2

  if spm_download -s $uri -o $executable; then
    chmod +x $executable
    echo "Downloaded binary file: $executable"
  else
    echo "Failed to download spm executable"
    clear_spm
  fi
}

download_executable $SPM_EXECUTABLE_URI $SPM_EXECUTABLE || {
  { echo "Failed to set permission on spm executable"; exit 1; }
}

# Add the bin directory to PATH and update it immediately
if [[ ":$PATH:" == *":$SPM_BIN:"* ]]; then
  echo "The spm bin directory is already in PATH"
else
  echo "export PATH=\"$SPM_BIN:\$PATH\"" >> "$HOME/.zshrc"
  if source "$HOME/.zshrc"; then
    echo "spm is ready to use"
  else
    echo "Failed to source .zshrc. Please manually add the following line to your .zshrc file:"
    echo "export PATH=\"$SPM_BIN:\$PATH\""
  fi
fi
