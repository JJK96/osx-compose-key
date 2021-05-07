#!/usr/bin/env bash

function get_version() {
    sw_vers -productVersion | awk 'BEGIN { FS = "." } ;{ printf "%s.%s", $1, $2 }'
}
OSX_VERSION="$(get_version)"

# Install Karabiner if it isn't installed, but homebrew and cask are.
if [[ "$(type -P brew)" && "$(brew tap | awk '/cask/')" ]]; then
  if [[ ! "$(brew list --casks 2>/dev/null | grep karabiner)" ]]; then
    echo "Installing Karabiner..."
	if (( $(echo "$OSX_VERSION > 10.12" | bc -l) )); then
	  brew install --cask karabiner-elements
	else
	  brew install --cask karabiner
	fi
  fi
  echo "Karabiner installed."
else
  echo "Homebrew and Homebrew Cask not detected. Not installing Karabiner."
  echo "If you intended for this script to install Karabiner, install"
  echo "Homebrew and Homebrew Cask:"
  echo
  echo "http://brew.sh/"
  echo "http://caskroom.io/"
  echo
fi

# Copy Karabiner settings.
echo "Copying Karabiner settings..."
if (( $(echo "$OSX_VERSION > 10.12" | bc -l) )); then
  mkdir -p ~/.config/karabiner
  cp karabiner.json ~/.config/karabiner/karabiner.json
else
  mkdir -p ~/Library/Application\ Support/Karabiner
  cp private.xml ~/Library/Application\ Support/Karabiner/private.xml
fi

# Copy DefaultKeyBinding.dict
mkdir -p ~/Library/KeyBindings
echo "Copying DefaultKeyBinding.dict..."
cp DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict

echo
echo "Done."
