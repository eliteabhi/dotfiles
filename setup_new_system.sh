#! /bin/bash

# Essential packages: paru( if arch ), aptitude( if ubuntu/debian ), git, stow, fish, neovim, vim, tmux, npm, python3.11, bat, exa 
# Other packages: openssh-client, python-is-python3, rustup, cargo, cmake, make, gcc, g++, vscode, gdb, lldb, macchina
# Optional packages: prettyping, docker, openssh-server, zerotier, alacritty

# Essential External packages: python: pip, pip: pipenv
# Other External packages: curl: curl: starship, git: nvchad, curl: tpm (Tmux package manager), curl: fisher, fisher: oh-my-fish/plugin-bang-bang, curl: tailscale

source /etc/os-release

# ---

OS="$ID_LIKE"
PACKAGE_MANAGER=""
NO_CONFIRM=""

UPGRADE=true

ESSENTIAL_PACKAGES=( "git" "fish" "vim" "tmux" )
OTHER_PACKAGES=()
OPTIONAL_PACKAGES=( "prettyping" "docker" "openssh-server" "zerotier" "alacritty" )

declare -rA ESSENTIAL_EXTERNAL_PACKAGES=( ["pip"]="python3 -m ensurepip"
                                        ["pipenv"]="pip install pipenv"
                                        ["neovim"]="sudo add-apt-repository ppa:neovim-ppa/unstable -y &&
                                          sudo aptitude update &&
                                          sudo aptitude install neovim"
                                      )

declare -rA OTHER_EXTERNAL_PACKAGES=( 
                                    ["starship"]="sudo curl -sS https://starship.rs/install.sh"
                                    ["nvchad"]="git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim" 
                                    ["tmuxpm"]="git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &&"
                                    ["fisher"]="curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
                                    ["pbb"]="fisher install oh-my-fish/plugin-bang-bang"
                                    ["tailscale"]="curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up"
                                    )

declare -rA OPTIONAL_EXTERNAL_PACKAGES=()

MINIMAL=false
FULL=true

DOTFILES_REMOTE_REPO_URL=""

# ---

printf "Retrieving OS...\n"
printf "Your OS is \`${OS}\` based\n"
echo
printf "Starting setup...\n"
echo
printf "Some preliminary questions:\n"
echo

# ---

case "${OS}" in 

  "arch")

    declare -A PACKAGE_MANAGER_OPTS=( ["install"]="-S" ["remove"]="-Rs" ["update"]="-Sy" ["upgrade"]="-Syuu" )
    
    read -n 1 -p "Do you want to use \`paru\` or \`yay\` as your package manager?[P/y]: " pm
    echo

    if [[ "${pm}" == "y" ]]; then 
      printf "Using \`yay\`...\n"
      sudo pacman -Sy yay yes --noconfirm
      PACKAGE_MANAGER="yay"

    else
      printf "Using \`paru\`...\n"     
      sudo pacman -Sy paru yes --noconfirm
      PACKAGE_MANAGER="paru"

    fi
    ;;

  "ubuntu")

    declare -A PACKAGE_MANAGER_OPTS=( ["install"]="install" ["remove"]="remove" ["upgrade"]="upgrade" )

    read -n 1 -p "Do you want to use \`aptitude\` as your package manager?[Y/n]: " pm 
    echo

    if [[ "${pm}" == "n" ]]; then
      printf "USING `apt-get`...\n"
      sudo apt-get install yes -y
      PACKAGE_MANAGER="sudo apt-get"

    else
      printf "Using \`aptitude\`...\n"
      sudo apt-get install aptitude yes -y
      PACKAGE_MANAGER="sudo aptitude"

    fi
    ;;

  *)
    printf "Not a supported distro type\n"
    exit 1
    ;;

esac

echo

# ---

if [ ${UPGRADE} ]; then
  
  upgrade_packages

else
  
  update_packages

fi

install_essential_packages
install_external_essential_packages

if [ ! ${MINIMAL} ]; then

  install_other_packages
  install_external_other_packages

elif [ ${FULL} ]

  install_optional_packages
  install_external_optional_packages

fi

setup_dotfiles

printf "Please restart your computer\n"
printf "Finished Setup!!\nHave a nice day!\n"

# ---

update_packages() {

  printf "Syncing packages..."
  bash -c "${NO_CONFIRM}${PACKAGE_MANAGER} ${PACKAGE_MANAGER_OPTS[\"update\"]}"

}

upgrade_packages() {

  printf "Upgrading packages..."
  bash -c "${NO_CONFIRM}${PACKAGE_MANAGER} ${PACKAGE_MANAGER_OPTS[\"update\"]} && ${NO_CONFIRM}${PACKAGE_MANAGER} ${PACKAGE_MANAGER_OPTS[\"upgrade\"]}"

}

install_essential_packages() {

if [[ -z "${ESSENTIAL_PACKAGES[@]}" ]]; then

  printf "No Essential Packages...\n"

else
  ESSENTIAL_PACKAGES_STRING=""
  for package in "${ESSENTIAL_PACKAGES[@]}"; do

    ESSENTIAL_PACKAGES_STRING="${ESSENTIAL_PACKAGES_STRING} ${package}"

  done

  ESSENTIAL_PACKAGES_STRING=${ESSENTIAL_PACKAGES_STRING#* }
  printf "Installing Essential packages: ${ESSENTIAL_PACKAGES_STRING}...\n"

  bash -c "${NO_CONFIRM}${PACKAGE_MANAGER} ${PACKAGE_MANAGER_OPTS[\"update\"]}"
  bash -c "${NO_CONFIRM}${PACKAGE_MANAGER} ${PACKAGE_MANAGER_OPTS[\"install\"]} ${ESSENTIAL_PACKAGES_STRING[@]}"
  echo

fi

}

install_other_packages() {

if [[ -z "${OTHER_PACKAGES[@]}" ]]; then

  printf "No Other Packages...\n"

else
  OTHER_PACKAGES_STRING=""
  for package in "${OTHER_PACKAGES}"; do

    OTHER_PACKAGES_STRING="${OTHER_PACKAGES_STRING} ${package}"

  done

  OTHER_PACKAGES_STRING=${OTHER_PACKAGES_STRING#* }
  printf "Installing Other packages: ${OTHER_PACKAGES_STRING}...\n"

  bash -c "${NO_CONFIRM}${PACKAGE_MANAGER} ${PACKAGE_MANAGER_OPTS[\"install\"]} ${OTHER_PACKAGES_STRING[@]}"
  echo

fi

}

install_optional_packages() {

if [[ -z "${OPTIONAL_PACKAGES[@]}" ]]; then
  
  printf "No Optional Packages...\n"

else
  OPTIONAL_PACKAGES_STRING=""
  for package in "${OPTIONAL_PACKAGES}"; do

    OPTIONAL_PACKAGES_STRING="${OPTIONAL_PACKAGES_STRING} ${package}"

  done
  
  OPTIONAL_PACKAGES_STRING=${OPTIONAL_PACKAGES_STRING#* }
  printf "Installing Optional packages: ${OPTIONAL_PACKAGES_STRING}...\n"

  bash -c "${NO_CONFIRM}${PACKAGE_MANAGER} ${PACKAGE_MANAGER_OPTS[\"install\"]} ${OPTIONAL_PACKAGES_STRING[@]}"
  echo

fi

}

install_external_essential_packages() {
 
if [[ -z "${ESSENTIAL_EXTERNAL_PACKAGES[@]}" ]]; then

  printf "No Essential External Packages...\n"

else
  ESSENTIAL_EXTERNAL_PACKAGES_STRING=""
  for package in "${!ESSENTIAL_EXTERNAL_PACKAGES[@]}"; do

    ESSENTIAL_EXTERNAL_PACKAGES_STRING="${ESSENTIAL_EXTERNAL_PACKAGES_STRING} ${package}"

  done

  ESSENTIAL_EXTERNAL_PACKAGES_STRING=${ESSENTIAL_EXTERNAL_PACKAGES_STRING#* }
  printf "Installing External Essential packages: ${ESSENTIAL_EXTERNAL_PACKAGES_STRING}...\n"

  for package in "${!ESSENTIAL_EXTERNAL_PACKAGES[@]}"; do

    printf "${package}: \"${OPTIONAL_EXTERNAL_PACKAGES["${package}"]}\""
    bash -c "${ESSENTIAL_EXTERNAL_PACKAGES[\"${package}\"]}"

  done
  echo

fi 

}

install_external_other_packages() {
 
if [[ -z "${OTHER_EXTERNAL_PACKAGES[@]}" ]]; then

  printf "No Other External Packages...\n"

else
  OTHER_EXTERNAL_PACKAGES_STRING=""
  for package in "${!OTHER_EXTERNAL_PACKAGES[@]}"; do

    OTHER_EXTERNAL_PACKAGES_STRING="${OTHER_EXTERNAL_PACKAGES_STRING} ${package}"

  done

  OTHER_EXTERNAL_PACKAGES_STRING=${OTHER_EXTERNAL_PACKAGES_STRING#* }
  printf "Installing External Other packages: ${OTHER_EXTERNAL_PACKAGES_STRING}...\n"

  for package in "${!OTHER_EXTERNAL_PACKAGES[@]}"; do
  
    printf "${package}: \"${OPTIONAL_EXTERNAL_PACKAGES["${package}"]}\""  
    bash -c "${OTHER_EXTERNAL_PACKAGES[\"${package}\"]}"

  done
  echo

fi 

}

install_external_optional_packages() {
 
if [[ -z "${OTHER_EXTERNAL_PACKAGES[@]}" ]]; then

  printf "No Optional External Packages...\n"

else
  OPTIONAL_EXTERNAL_PACKAGES_STRING=""
  for package in "${!OPTIONAL_EXTERNAL_PACKAGES[@]}"; do

    OPTIONAL_EXTERNAL_PACKAGES_STRING="${OPTIONAL_EXTERNAL_PACKAGES_STRING} ${package}"

  done

  OPTIONAL_EXTERNAL_PACKAGES_STRING=${OPTIONAL_EXTERNAL_PACKAGES_STRING#* }
  printf "Installing External Optional packages: ${OPTIONAL_EXTERNAL_PACKAGES_STRING}...\n"

  for package in "${!OPTIONAL_EXTERNAL_PACKAGES[@]}"; do
    
    printf "${package}: \"${OPTIONAL_EXTERNAL_PACKAGES["${package}"]}\""
    bash -c "${OPTIONAL_EXTERNAL_PACKAGES[\"${package}\"]}"

  done
  echo

fi 

}

setup_dotfiles() {

  echo "Setting up dotfiles...\n"
  CMD=""
  local STOW_ARGS=""
  
  CMD="cd ${HOME} && git clone ${DOTFILES_REMOTE_REPO_URL}"
   
  read -n 1 -p "Adopt current dotfiles config or replace with repo's?[a/R]: " override

  if [[ "${override}" == "a" ]]
    STOW_ARGS="--adopt"

  else
    STOW_ARGS="--override=*"
  
  fi

  CMD="${CMD} && cd ./dotfiles && stow . ${STOW_ARGS}"

  bash -c "${CMD}"

}

# ---

exit 0

