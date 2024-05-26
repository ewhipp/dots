#!/bin/bash

## Ensure that errors come through
set -e

set_pkg_mgr() {
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		sudo dnf clean all && \
		sudo dnf makecache && \
		sudo dnf install -y python3 python3-devel python3-pip python3-wheel gcc git
		echo "dnf"
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		# Mac OSX
		if ! [ -x "$(command -v brew)" ]; then
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi
		echo "brew"
	fi
}
GIT_HOME="$HOME/Documents/Resources/code"
DOTFILES_DIR="$GIT_HOME/dots/fedora"
CONFIG_DIR="$DOTFILES_DIR/.config"
SSH_DIR="$HOME/.ssh"
PKG_MGR=$(set_pkg_mgr)

echo PKG_MGR=$PKG_MGR


if ! [ -x "$(command -v ansible)" ]; then
	echo $($PKG_MGR = "dnf")
	$([ "$PKG_MGR" = "dnf" ] && sudo "$PKG_MGR" install -y ansible || "$PKG_MGR" install ansible)
fi

if ! [[ -f "$SSH_DIR/id_rsa" ]]; then
	mkdir -p "$SSH_DIR"
	chmod 700 "$SSH_DIR"

	ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"
	cat "$SSH_DIR/id_rsa.pub" >> "$SSH_DIR/authorized_keys"
	chmod 600 "$SSH_DIR/authorized_keys"
fi

if ! [[ -d "$DOTFILES_DIR" ]]; then
  git clone "https://github.com/ewhipp/dots.git" "$GIT_HOME"
else
  cd "$GIT_HOME/dots" && \
  git -C "$GIT_HOME/dots" pull
fi

if [[ -f "$DOTFILES_DIR/requirements.yml" ]]; then
	cd "$DOTFILES_DIR"

	ansible-galaxy install -r requirements.yml
fi

cd "$DOTFILES_DIR"
ansible-playbook --diff --extra-vars "@$CONFIG_DIR/values.yml" "$DOTFILES_DIR/main.yml" "$@"


