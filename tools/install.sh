#!/usr/bin/env bash

set -euo pipefail

SPM_HOME="$HOME/.spm"
SPM_BIN="$SPM_HOME/bin"
SPM_RECORD="$SPM_HOME/record"
SPM_EXECUTABLE="$SPM_BIN/spm"
SPM_EXECUTABLE_URI="https://raw.githubusercontent.com/barnett617/shell-path-manager/main/bin/spm"

error() {
  echo -e "Error: " "$@" >&2
  exit 1
}

if [ ! -d $SPM_BIN ]; then
  mkdir -p "$SPM_BIN" ||
    error "Failed to create directory: $SPM_BIN"
else
  error "Directory already exists: $SPM_HOME"
fi

if [ ! -f "$SPM_RECORD" ]; then
  touch "$SPM_RECORD"
else
  error "File already exists: $SPM_RECORD"
fi

curl --fail --location --progress-bar --output "$SPM_EXECUTABLE" "$SPM_EXECUTABLE_URI" ||
  error "Failed to download spm executable"

chmod +x "$SPM_EXECUTABLE" ||
  error "Failed to set permission on spm executable"

refresh_command=''

echo

case $(basename "$SHELL") in
zsh)
  SHELL=zsh $SPM_EXECUTABLE completions &>/dev/null || :

  commands=(
    "export PATH=\"$SPM_BIN:\$PATH\""
  )

  zsh_config=$HOME/.zshrc

  if [[ -w $zsh_config ]]; then
    {
      echo "# spm start"

      for command in "${commands[@]}"; do
        echo "$command"
      done

      echo "# spm end"
    } >>"$zsh_config"

    echo "Added \"$SPM_BIN\" to \$PATH in \"$zsh_config\""

    refresh_command="exec $SHELL"
  else
    echo "Mannually add the directory to $zsh_config file:"

    for command in "${commands[@]}"; do
      echo "$command"
    done
  fi
  ;;
bash)
  SHELL=bash $SPM_EXECUTABLE completions &>/dev/null || :

  commands=(
    "export PATH=\"$SPM_BIN:\$PATH\""
  )

  bash_configs=(
    "$HOME/.bashrc"
    "$HOME/.bash_profile"
  )

  for bash_config in "${bash_configs[@]}"; do
    if [[ -w $bash_config ]]; then
      {
        echo "# spm start"

        for command in "${commands[@]}"; do
          echo "$command"
        done

        echo "# spm end"
      } >>"$bash_config"

      echo "Added \"$SPM_BIN\" to \$PATH in \"$bash_config\""

      refresh_command="source $bash_config"
      break
    else
      echo "Mannually add the directory to $bash_config file:"

      for command in "${commands[@]}"; do
        echo "$command"
      done
    fi
  done
  ;;
*)
  echo "Mannual add the directory to ~/.bashrc (or similar):"

  for command in "${commands[@]}"; do
    echo "$command"
  done
  ;;
esac

echo
echo "To get started, run: "
echo

if [[ -n $refresh_command ]]; then
  echo "$refresh_command"
fi
