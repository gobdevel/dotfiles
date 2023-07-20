#!/bin/env bash

# Author: Gobind Prasad
# Initial config for new linux system

PROGNAME=$0
EXIT_FAILURE=1
EXIT_SUCCESS=0

usage() {
  echo "Usage: 
  $PROGNAME [-a <arg>] [-b <arg>] [-c <arg>] file
  New Developer Linux Setup Script" 1>&2;
  exit $EXIT_FAILURE
}

install_package() {
  local package=$1
  sudo apt-get update  # To get the latest package lists
  sudo apt-get install $package -y
}

ensure_package() {
  local pkg=$1
  pkg_path=`which $pkg`
  if [[ -z $pkg_path ]]; then
    echo "No $pkg found, installing..."
    install_package $pkg
  fi
}

ensure_oh_my_zsh() {
  readonly local oh_my_zsh=$HOME/.oh-my-zsh
  if [[ ! -d $oh_my_zsh ]]; then
    echo "Installing oh my zsh ..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  fi
}

ensure_ssh_keys() {
  readonly local ssh_dir=$HOME/.ssh
  if [[ ! -d $ssh_dir ]]; then
    echo "Generating host ssh key pairs..."
    ssh-keygen -t ed25519 -b 256 -N ''
    echo "Copy contents $HOME/.ssh/id_ed25519.pub to git server. After that run this script again."
    exit $EXIT_SUCCESS
  fi 
}

setup_dotfiles() {
  readonly local dotfiles="$HOME/dotfiles"
  if [[ ! -d $dotfiles ]]; then
    git clone git@github.com:gobdevel/dotfiles.git $dotfiles
  fi
  ln -sf $dotfiles/zshrc $HOME/.zshrc
  ln -sf $dotfiles/zsh-alias $HOME/.zsh-alias
  ln -sf $dotfiles/p10k.zsh $HOME/.p10k.zsh
  ln -sf $dotfiles/nvim $HOME/.config/nvim
}

ensure_tmux() {
  readonly local tmux_repo=$HOME/oh_my_tmux
  if [[ ! -d $tmux_repo ]]; then
    echo "Setting up TMUX ..."
    ensure_package tmux
    git clone https://github.com/gpakosz/.tmux.git $tmux_repo
    mkdir -p "$HOME/.config/tmux"
    ln -s "$tmux_repo/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
    cp "$tmux_repo/.tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"
  fi
}

install_nvim() {
  mkdir -p $HOME/bin
  pushd $HOME/bin
  echo "Downloading latest version of Neovim ..."
  curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -o nvim.appimage
  chmod 755 nvim.appimage
  ./nvim.appimage --appimage-extract  &>/dev/null
  ln -sf $HOME/bin/squashfs-root/usr/bin/nvim $HOME/bin/nvim
  popd
}

setup_nvim() {
  readonly local nvim=$HOME/bin/nvim
  if [[ ! -f $nvim ]]; then
    install_nvim
    git clone https://github.com/NvChad/NvChad $HOME/bin/NvChad --depth 1
    ln -sf $HOME/dotfiles/nvchad-custom $HOME/bin/NvChad/lua/custom 

    # TODO ensure_package npm nodejs
    readonly local NVIM_APSTRA=$HOME/.config/nvim-chad
    rm -rf $NVIM_APSTRA
    mkdir -p $NVIM_APSTRA/share
    ln -sf $HOME/bin/NvChad $NVIM_APSTRA/nvim
  fi 
}

ensure_package curl
ensure_package git
ensure_package zsh
ensure_oh_my_zsh
ensure_tmux
ensure_ssh_keys
setup_dotfiles
setup_nvim

exit $EXIT_SUCCESS
