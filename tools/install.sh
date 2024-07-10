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

# Create the bin directory inside .spm if it doesn't exist
if [ ! -d "$SPM_BIN" ]; then
  mkdir "$SPM_BIN"
  echo "Created directory: $SPM_BIN"
else
  echo "Directory already exists: $SPM_BIN"
fi

# Create the record file inside .spm if it doesn't exist
if [ ! -f "$SPM_RECORD" ]; then
  touch "$SPM_RECORD"
  echo "Created file: $SPM_RECORD"
else
  echo "File already exists: $SPM_RECORD"
fi

# Check if the file exist
spm_has() {
  type "$1" >/dev/null 2>&1
}

# Download helper
spm_download() {
  if spm_has "curl"; then
    echo "Downloading binary file: $uri"
    curl -# --fail --compressed -q "$@"
  fi
}

# Clear helper
clear_spm() {
  rm -rf "$SPM_HOME"
}

# Append spm bin directory to PATH
append_path() {
  # Switch to Zsh
  chsh -s /bin/zsh

  # Add the bin directory to PATH
  echo "export PATH=\"$SPM_BIN:\$PATH\"" >>"$HOME/.zshrc"
  if source "$HOME/.zshrc"; then
    echo "spm is ready to use"
  else
    echo "Failed to source .zshrc. Please manually add the following line to your .zshrc file:"
    echo "export PATH=\"$SPM_BIN:\$PATH\""
  fi
}

# Download the spm executable and set permission
if spm_download $SPM_EXECUTABLE_URI $SPM_EXECUTABLE; then
  if chmod +x $SPM_EXECUTABLE; then
    append_path
  else
    echo "Failed to set permission on spm executable"
    echo "Please manually add the following line to your .zshrc file:"
    echo "export PATH=\"$SPM_BIN:\$PATH\""
  fi
else
  echo "Failed to download spm executable"
  clear_spm
  exit 1
fi
