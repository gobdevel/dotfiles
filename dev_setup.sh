#!/bin/env bash

# Author: Gobind Prasad
# Initial config for new linux system

PROGNAME=$0
EXIT_FAILURE=1
EXIT_SUCCESS=0
readonly OH_MY_ZSH="$HOME/.oh-my-zsh"
readonly SSH_DIR="$HOME/.ssh"
readonly DOTFILES="$HOME/dotfiles"
readonly TMUX_REPO="$HOME/oh_my_tmux"
readonly NVIM_BIN="$HOME/bin/nvim"
readonly NVIM_APSTRA="$HOME/.config/nvim-chad"

help() {
   # Display Help
   echo "New Developer Linux Setup Script"
   echo
   echo "Syntax: $PROGNAME [-g|h|v|V]"
   echo "options:"
   echo "i     Install."
   echo "h     Help."
   echo "u     Uninstall."
   echo "p     Update."
   echo
}

install_package() {
  local package=$1
  sudo apt-get update  # To get the latest package lists
  sudo apt-get install "$package" -y
}

ensure_package() {
  local pkg=$1
  pkg_path=$(which "$pkg")
  if [[ -z $pkg_path ]]; then
    echo "No $pkg found, installing..."
    install_package "$pkg"
  fi
}

ensure_oh_my_zsh() {
  if [[ ! -d $OH_MY_ZSH ]]; then
    echo "Installing oh my zsh ..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autocomplete
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  fi
}

ensure_ssh_keys() {
  if [[ ! -d $SSH_DIR ]]; then
    echo "Generating host ssh key pairs..."
    ssh-keygen -t ed25519 -b 256 -N ''
    echo "Copy contents $HOME/.ssh/id_ed25519.pub to git server. After that run this script again."
    exit $EXIT_SUCCESS
  fi 
}

setup_dotfiles() {
  if [[ ! -d $DOTFILES ]]; then
    git clone git@github.com:gobdevel/dotfiles.git "$DOTFILES"
  fi
  ln -sf "$DOTFILES/zshrc" "$HOME/.zshrc"
  ln -sf "$DOTFILES/zsh-alias" "$HOME/.zsh-alias"
  ln -sf "$DOTFILES/p10k.zsh" "$HOME/.p10k.zsh"
  ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
}

ensure_tmux() {
  if [[ ! -d $TMUX_REPO ]]; then
    echo "Setting up TMUX ..."
    ensure_package tmux
    git clone https://github.com/gpakosz/.tmux.git "$TMUX_REPO"
    mkdir -p "$HOME/.config/tmux"
    ln -s "$TMUX_REPO/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
    cp "$TMUX_REPO/.tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"
  fi
}

install_nvim() {
  mkdir -p "$HOME/bin"
  pushd "$HOME/bin" || exit $EXIT_FAILURE
  echo "Downloading latest version of Neovim ..."
  curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -o nvim.appimage
  chmod 755 nvim.appimage
  ./nvim.appimage --appimage-extract  &>/dev/null
  ln -sf "$HOME/bin/squashfs-root/usr/bin/nvim" "$NVIM_BIN"
  popd || exit $EXIT_FAILURE
}

setup_nvim() {
  if [[ ! -f $NVIM_BIN ]]; then
    install_nvim
    git clone https://github.com/NvChad/NvChad "$HOME/bin/NvChad" --depth 1
    ln -sf "$HOME/DOTFILES/nvchad-custom" "$HOME/bin/NvChad/lua/custom" 

    # TODO ensure_package npm nodejs
    ensure_package shellcheck
    rm -rf "$NVIM_APSTRA"
    mkdir -p "$NVIM_APSTRA/share"
    ln -sf "$HOME/bin/NvChad" "$NVIM_APSTRA/nvim"
  fi 
}

install() {
  ensure_package curl
  ensure_package git
  ensure_package zsh
  ensure_oh_my_zsh
  ensure_tmux
  ensure_ssh_keys
  setup_dotfiles
  setup_nvim
}

uninstall() {
  # Remove bin NVIM 
  rm -rf "$HOME/bin"
  rm -rf "$NVIM_APSTRA"

  # Remove TMUX
  rm -rf "$HOME/.config/tmux"
  rm -rf "$TMUX_REPO"

  # Remove oh_my_zsh
  rm -rf "$OH_MY_ZSH"

  rm -rf "$HOME/.zshrc" \
         "$HOME/.zsh-alias" \
         "$HOME/.p10k.zsh" \
         "$HOME/.config/nvim" 
}

# Get the options
while getopts ":hiup:" option; do
   case $option in
      h) # display Help
         help
         exit;;
      i) # Enter a name
         install;;
      u) # uninstall
         uninstall;;
      p) # update
         update;;
     \?) # Invalid option
         echo "Error: Invalid option"
         help
         exit;;
   esac
done

exit $EXIT_SUCCESS
