# Remove the bin directory from PATH if exists
function remove_spm_path() {
  if [[ ":$PATH:" == *":$SPM_BIN:"* ]]; then
    export PATH=$(echo $PATH | sed "s|:$SPM_BIN:|::" | sed "s|^:$||" | sed "s|:$||")
    echo "Removed the spm bin directory from PATH"
  else
    echo "The spm bin directory is not in PATH"
  fi
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