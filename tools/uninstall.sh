#!/usr/bin/env bash

SPM_HOME="$HOME/.spm"
SPM_RECORD="$SPM_HOME/record"
default_shell=$(basename "$SHELL")

function uninstall() {
  if rm -rf "$SPM_HOME"; then
    echo "All spm related files are removed"
  else
    echo "Failed to remove $SPM_HOME"
  fi

  local rc_file=""
  if [ "$default_shell" == "bash" ]; then
    rc_file="$HOME/.bashrc"
  elif [ "$default_shell" == "zsh" ]; then
    rc_file="$HOME/.zshrc"
  else
    echo "Unsupported shell: $default_shell"
  fi

  if [[ -w "$rc_file" ]]; then
    # remove the lines between "# spm start" and "# spm end"
    sed -i '' '/^# spm start/,/# spm end/d' "$rc_file" ||
      echo "Warning: Failed to remove spm related lines from $rc_file"
  else
    echo "Warning: Failed to write to $rc_file"
  fi

}

set -eu
uninstall
