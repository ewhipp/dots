#!/bin/bash

set -e
GIT_HOME="$HOME/Documents/Resources/code"
DOTFILES_DIR="$GIT_HOME/dots"
CONFIG_DIR="$HOME/.ansible/config"
VAULT="$HOME/.ansible/vault"
SSH_DIR="$HOME/.ssh"
pwd=$(pwd)
HOMEBREW_INSTALL=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) machine=Linux ;;
Darwin*) machine=Mac ;;
*) machine="UNKNOWN:${unameOut}" ;;
esac

echo $machine

set_pkg_mgr() {

    echo "checking os and readiness"
    if [[ $machine == "Linux" ]]; then
        echo "test"
        echo "on fedora, gathering dnf"
        sudo dnf clean all >/dev/null && \
        sudo dnf makecache >/dev/null && \
        sudo dnf install -y python3 python3-devel python3-pip python3-wheel gcc git
        echo "dnf"
    elif [[ "$machine" == "Mac" ]]; then
        # Mac OSX
        if ! command -v brew &>/dev/null; then
            export PATH="/opt/homebrew/bin:/usr/local/bin:${PATH}"
            # NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL $HOMEBREW_INSTALL)" &&
            #     (
            #         echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
            #     ) >>/Users/$(whoami)/.zprofile &&

            #     eval "$(/opt/homebrew/bin/brew shellenv)"

            brew install python3 git
        fi
    fi
}

set_pkg_mgr

if ! command -v ansible &>/dev/null; then
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
    cat "$SSH_DIR/id_rsa.pub" >>"$SSH_DIR/authorized_keys"
    chmod 600 "$SSH_DIR/authorized_keys"
fi

if ! [[ -f "$SSH_DIR/id_ed25519" ]]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"

    ssh-keygen -t ed25519 -f "$SSH_DIR/id_ed25519" -a 100 -C "$EMAIL"
    cat "$SSH_DIR/id_ed25519.pub" >>"$SSH_DIR/authorized_keys"
    chmod 600 "$SSH_DIR/authorized_keys"
fi

# Setup python environment
PATH="$(python3 -m site --user-base)/bin:${PATH}"
export PATH
python3 -m venv $DOTFILES_DIR/.venv
source $DOTFILES_DIR/.venv/bin/activate

pip install virtualenv
virtualenv .venv
#shellcheck disable=SC1091
pip install --requirement requirements.txt

cd $DOTFILES_DIR

# Setup Ansible
if ! [[ -d "$DOTFILES_DIR" ]]; then
    git clone "https://github.com/ewhipp/dots.git" "$GIT_HOME"
    cd "$GIT_HOME/dots"
else
    cd "$GIT_HOME/dots" &&
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
    echo "Running secrets ansible playbook"
    cd $DOTFILES_DIR
    ansible-playbook "$DOTFILES_DIR/playbooks/secrets.yml"
    cd $pwd
    exit 0
fi

if [ "$1" = "setup" ]; then
    echo "Running setup ansible script"
    cd $DOTFILES_DIR
    ANSIBLE_CONFIG=setup.cfg ansible-playbook $DOTFILES_DIR/site.yml
    cd $pwd
    exit 0
fi

if [ $# -eq 0 ]; then
    echo "Running machine configuration ansible setup"
    cd "$DOTFILES_DIR"
    ansible-playbook --vault-password-file "$VAULT_ID" playbooks/bootstrap.yml
    cd $pwd
    exit 0
fi
