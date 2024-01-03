#!/usr/bin/env bash

# Author: Gobind Prasad
# Initial config for new linux system

PROGNAME=$0
EXIT_FAILURE=1
EXIT_SUCCESS=0

APT="sudo apt-get"
OS_TYPE="Linux"

if [[ $(uname -s) == "Darwin" ]]; then
  APT="brew"
  OS_TYPE="Mac"
fi

readonly OH_MY_ZSH="$HOME/.oh-my-zsh"
readonly SSH_DIR="$HOME/.ssh"
readonly DOTFILES="$HOME/dotfiles"
readonly TMUX_REPO="$HOME/oh_my_tmux"
readonly NVIM_BIN="$HOME/bin/nvim"
readonly NVIM_CONF_DIR="$HOME/.config/nvim-chad"

help() {
  # Display Help
  echo "New Developer Linux Setup Script"
  echo
  echo "Syntax: $PROGNAME [-i|h|u|r|e]"
  echo "options:"
  echo "h     Help."
  echo "i     Install."
  echo "u     Update."
  echo "r     Uninstall."
  echo "e     Exit."
  echo
}

install_package() {
  local package=$1
  if [[ ${OS_TYPE} == "Linux" ]]; then
    ${APT} update  # To get the latest package lists
    ${APT} install "$package" -y
  else
    ${APT} update
    ${APT} install "$package"
  fi
}

ensure_package() {
  # Declare an array
  declare -a pkg=("$1" "$2")
  pkg_path=$(which "${pkg[1]}")
  if [[ -z $pkg_path ]]; then
    echo "No ${pkg[0]} found, installing..."
    install_package "${pkg[0]}"
  fi
}

ensure_packages() {
  # Declare an array
  declare -a pkgs=(
    "ripgrep rg"
    "zsh zsh"
    "curl curl"
    "git git"
    "fzf fzf"
  "tmux tmux")
  for item in "${pkgs[@]}"; do
    # read each item to an array
    read -r -a pkg <<< "$item"
    ensure_package "${pkg[@]}"
  done
}

ensure_oh_my_zsh() {
  if [[ ! -d $OH_MY_ZSH ]]; then
    echo "Installing oh my zsh ..."
    echo "exit" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autocomplete
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
  fi
}

generate_ssh_keys() {
  echo "Generating host ssh key pairs..."
  # ssh-keygen -t ed25519 -b 256 -N ''
  echo "Copy contents $HOME/.ssh/id_ed25519.pub to git server. After that run this script again."
  exit $EXIT_SUCCESS
}

ensure_ssh_keys() {
  if [[ ! -d $SSH_DIR ]]; then
    while true; do
      echo "This will generate a new ssh key pair."
      read -r -p "Do you want to continue? (y/n) " yn
      case $yn in
        [Yy]* ) generate_ssh_keys; break ;;
        [Nn]* ) break ;;
        * ) echo "Please answer yes or no." ;;
      esac
    done
  fi
}

setup_dotfiles() {
  if [[ ! -d $DOTFILES ]]; then
    git clone git@github.com:gobdevel/dotfiles.git "$DOTFILES"
  fi
  ln -sf "$DOTFILES/zshrc" "$HOME/.zshrc"
  ln -sf "$DOTFILES/zsh-alias" "$HOME/.zsh-alias"
  ln -sf "$DOTFILES/p10k.zsh" "$HOME/.p10k.zsh"
  ln -sf "$DOTFILES/clang-format" "$HOME/.clang-format"
}

ensure_tmux() {
  if [[ ! -d $TMUX_REPO ]]; then
    echo "Setting up TMUX ..."
    git clone https://github.com/gpakosz/.tmux.git "$TMUX_REPO"
    mkdir -p "$HOME/.config/tmux"
    ln -s "$TMUX_REPO/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
    cp "$TMUX_REPO/.tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"
  fi
}

install_nvim() {
  if [[ ${OS_TYPE} == "Mac" ]]; then
    ensure_package neovim nvim
  else
    mkdir -p "$HOME/bin"
    pushd "$HOME/bin" || exit $EXIT_FAILURE
    echo "Downloading latest version of Neovim ..."
    # Check what kind of processor is, Ubuntu on Macos as Docker
    processor=$(lscpu | grep Architecture | awk '{print $2}')
    if [[ ${processor} == "aarch64" ]]; then
      echo "Please Install neovim from source...."
    else
        curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -o nvim.appimage
        chmod 755 nvim.appimage
        ./nvim.appimage --appimage-extract  &>/dev/null
        ln -sf "$HOME/bin/squashfs-root/usr/bin/nvim" "$NVIM_BIN"
    fi
    popd || exit $EXIT_FAILURE
  fi
}

setup_nvim() {
  if [[ ${OS_TYPE} == "Mac" ]]; then
    install_nvim
  else
    if [[ ! -f ${NVIM_BIN} ]]; then
      install_nvim
    fi
  fi

  if [[ ! -d $NVIM_CONF_DIR ]]; then
    git clone https://github.com/NvChad/NvChad "$HOME/bin/NvChad" --depth 1

    ln -sf "$DOTFILES/nvchad-custom" "$HOME/bin/NvChad/lua/custom"
    rm -rf "$NVIM_CONF_DIR"
    mkdir -p "$NVIM_CONF_DIR/share"
    ln -sf "$HOME/bin/NvChad" "$NVIM_CONF_DIR/nvim"
  fi
}

install() {
  ensure_oh_my_zsh
  setup_dotfiles
  ensure_packages
  ensure_tmux
  ensure_ssh_keys
  setup_nvim
}

install_neovim() {
  ensure_packages
  setup_nvim
}

uninstall() {
  # Remove bin NVIM
  rm -rf "$HOME/bin"
  rm -rf "$NVIM_CONF_DIR"

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

update() {
  echo "Running update..."
  ensure_packages
}

# Get the options
while getopts ":hiurev:" option; do
  case $option in
    h) # display Help
      help
      exit ;;
    i) # Enter a name
      install ;;
    u) # uninstall
      update ;;
    r) # update
      uninstall ;;
    v) # Neo Vim Only
      install_neovim ;;
    e) # update
      exit ;;
    \?) # Invalid option
      echo "Error: Invalid option"
      help
      exit ;;
  esac
done

exit $EXIT_SUCCESS
