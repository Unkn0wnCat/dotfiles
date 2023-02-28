#!/usr/bin/env bash

# Source: https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

echo "Installing NixOS..."

if [ -d /etc/nixos/ssh ]; then
  echo "Directory /etc/nixos/ssh exists - skipping."
else
  sudo ln -s $DIR/../ssh /etc/nixos/ssh || echo "Could not link ssh assets"
fi

pushd $DIR

sudo nixos-rebuild switch --flake '..#' --impure

popd

#sudo cp -r $DIR/../* /etc/nixos/ || echo "Could not copy modules"

echo "Done."
