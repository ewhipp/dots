#!/bin/bash

set -e
GIT_HOME="$HOME/Documents/Resources/code"
DOTFILES_DIR="$GIT_HOME/dots/fedora"
CONFIG_DIR="$DOTFILES_DIR/.config"
VAULT="$DOTFILES_DIR/.ansible/vault"
SSH_DIR="$HOME/.ssh"
pwd=$(pwd)

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

echo $machine

set_pkg_mgr() {

	echo "checking os and readiness"
    if [[ $machine == "Linux" ]]; then
        echo "test"
	echo "on fedora, gathering dnf"
        sudo dnf clean all  > /dev/null && \
        sudo dnf makecache > /dev/null && \
        sudo dnf install -y python3 python3-devel python3-pip python3-wheel gcc git
        echo "dnf"
    elif [[ "$machine" == "Mac" ]]; then
    # Mac OSX
        if ! command -v brew &> /dev/null 
	then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
	    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$(whoami)/.zprofile && \
    eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        echo "brew"
    fi
}

set_pkg_mgr

if ! command -v ansible &> /dev/null
then
	if [[ $machine == "Linux" ]]; then
		sudo dnf install -y ansible
	elif [[ $machine == "Mac" ]]; then
		brew install ansible
	fi
fi

# Generate ssh keys for working with Git
if ! [[ -f "$SSH_DIR/id_rsa" ]]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    
    ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"
    cat "$SSH_DIR/id_rsa.pub" >> "$SSH_DIR/authorized_keys"
    chmod 600 "$SSH_DIR/authorized_keys"
fi

if ! [[ -f "$SSH_DIR/id_ed25519" ]]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    
    ssh-keygen -t ed25519 -f "$SSH_DIR/id_ed25519" -a 100 -C "$EMAIL"
    cat "$SSH_DIR/id_ed25519.pub" >> "$SSH_DIR/authorized_keys"
    chmod 600 "$SSH_DIR/authorized_keys"
fi

# Setup Ansible
if ! [[ -d "$DOTFILES_DIR" ]]; then
    git clone "https://github.com/ewhipp/dots.git" "$GIT_HOME"
    cd "$GIT_HOME/dots"
else
    cd "$GIT_HOME/dots" && \
    git -C "$GIT_HOME/dots" pull
fi

if [[ -f "$DOTFILES_DIR/requirements.yml" ]]; then
    cd "$DOTFILES_DIR"
    
    ansible-galaxy install -r requirements.yml
fi

if ! [[ -f "$DOTFILES_DIR/.ansible/vault.yml" ]]; then
    ansible-vault create $DOTFILES_DIR/.ansible/vault.yml
fi

if [ "$1" = "secrets" ]; then
    cd $DOTFILES_DIR
    ansible-playbook --diff --extra-vars "@$CONFIG_DIR/values.yml" "$DOTFILES_DIR/secrets.yml" "$@"
    cd $pwd
    exit 0
fi

cd "$DOTFILES_DIR"
ansible-playbook --diff --extra-vars "@$CONFIG_DIR/values.yml" "$DOTFILES_DIR/main.yml" "$@"

cd $pwd
