SPM_HOME="$HOME/.spm"
SPM_BIN="$SPM_HOME/bin"

echo "Removing ~/.spm"
if [ -d "$SPM_HOME" ]; then
  rm -rf "$SPM_HOME"
else
  echo "The spm home directory does not exist"
fi
