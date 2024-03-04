#! /bin/bash

# Essential packages: paru( if arch ), aptitude( if ubuntu/debian ), git, stow, fish, neovim, vim, tmux, npm, python3.11, bat, exa 
# Other packages: openssh-client, python-is-python3, rustup, cargo, cmake, make, gcc, g++, vscode, gdb, lldb, macchina
# Optional packages: prettyping, docker, openssh-server, zerotier, alacritty

# Essential External packages: python: pip, pip: pipenv
# Other External packages: curl: starship, git: nvchad, curl: tpm (Tmux package manager), curl: fisher, fisher: oh-my-fish/plugin-bang-bang, curl: tailscale

source /etc/os-release

# ---

OS="$ID_LIKE"
PACKAGE_MANAGER=""
NO_CONFIRM=""

ESSENTIAL_PACKAGES=( "git" "fish" "vim" "tmux" )
OTHER_PACKAGES=
OPTIONAL_PACKAGES=( "prettyping" "docker" "openssh-server" "zerotier" "alacritty" )

declare -A ESSENTIAL_EXTERNAL_PACKAGES=( ["pip"]="python3 -m ensurepip" ["pipenv"]="pip install pipenv" )
declare -A ESSENTIAL_PACKAGES_SPECIAL_ARGS=( ["pipenv"]="--break_system_packages" )
declare -A ESSENTIAL_EXTERNAL_PACKAGES_OS_ARGS=( ["ubuntu"]= )
declare -A ESSENTIAL_SPECIAL_CASES=( "neovim" )

# ---

echo "Retrieving OS..."
echo "Your OS is \`${OS}\` based"
echo
echo "Starting setup..."
echo
echo "Some preliminary questions:"
echo

# ---

case "${OS}" in 

  "arch")

    read -n 1 -p "Do you want to use \`paru\` or \`yay\` as your package manager?[P/y]: " pm
    echo

    NO_CONFIRM="--noconfirm"
    if [[ "${pm}" == "y" ]]; then 
      sudo pacman -Sy yay ${NO_CONFIRM}
      PACKAGE_MANAGER="yay"

    else
      sudo pacman -Sy paru ${NO_CONFIRM}
      PACKAGE_MANAGER="paru"

    fi
    ;;

  "ubuntu")

    read -n 1 -p "Do you want to use \`aptitude\` as your package manager?[Y/n]: " pm 
    echo

    if [[ "${pm}" == "n" ]]; then
      PACKAGE_MANAGER="apt-get"

    else
      PACKAGE_MANAGER="aptitude"

    fi
      
esac



