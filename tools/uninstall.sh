SPM_HOME="$HOME/.spm"
SPM_BIN="$SPM_HOME/bin"

echo "Start to uninstall spm..."
if [ -d "$SPM_HOME" ]; then
  rm -rf "$SPM_HOME"
  echo "Removed ~/.spm"
  echo "Uninstalled spm successfully"
else
  echo "The spm home directory does not exist"
fi
