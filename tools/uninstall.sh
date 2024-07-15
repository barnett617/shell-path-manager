SPM_HOME="$HOME/.spm"
SPM_BIN="$SPM_HOME/bin"

# Remove the bin directory from PATH if exists
function remove_spm_path() {
    export PATH=$(echo "${PATH}" | sed '|'"$SPM_BIN":||g' | sed '|:?'"$SPM_BIN"'||g')
}
# Uninstall spm
function uninstall() {
  if rm -rf "$SPM_HOME"; then
    echo "All spm related files are removed"
  else
    echo "Failed to remove $SPM_HOME"
  fi

  remove_spm_path
}

uninstall
