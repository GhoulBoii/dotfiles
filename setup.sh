#!/usr/bin/env bash

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 6)
normal=$(tput sgr0)

setup_dotfiles() {
  echo -e "${blue}DOTFILES${normal}"
  cd
  git clone --depth=1 --separate-git-dir=.dots https://github.com/ghoulboii/dotfiles tmpdotfiles
  git --git-dir=.dots --work-tree=~ remote set-url origin git@github.com:ghoulboii/dotfiles
  git --git-dir=.dots --work-tree=~ config --local status.showUntrackedFiles no
  rsync --recursive --verbose --exclude '.git' tmpdotfiles/ .
  rm -rf tmpdotfiles
  mkdir ~/{dl,doc,pics}
  xdg-user-dirs-update
  echo 'ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"' > /etc/zsh/zshenv
}

setup_paru() {
  echo -e "${blue}PARU${normal}"
  git clone --depth=1 https://aur.archlinux.org/paru-bin.git ~/.local/src/paru
  cd ~/.local/src/paru
  makepkg --noconfirm -rsi
  rm -rf ~/.local/src/paru
}

setup_dwm() {
  echo -e "${blue}DWM${normal}"
  git clone --depth=1 https://github.com/ghoulboii/dwm ~/.local/src/dwm
  git --git-dir=~/.local/src/dwm/.git --work-tree=~/.local/dwm/st remote set-url origin git@github.com:$(whoami)/dwm
  sudo make -sC ~/.local/src/dwm install
}

setup_dwmblocks() {
  echo -e "${blue}DWMBLOCKS${normal}"
  git clone --depth=1 https://github.com/ghoulboii/dwmblocks ~/.local/src/dwmblocks
  git --git-dir=~/.local/src/dwmblocks/.git --work-tree=~/.local/src/dwmblocks remote set-url origin git@github.com:$(whoami)/dwmblocks
  sudo make -sC ~/.local/src/dwmblocks install
}

setup_st() {
  echo -e "${blue}ST${normal}"
  git clone --depth=1 https://github.com/ghoulboii/st ~/.local/src/st
  git --git-dir=~/.local/src/st/.git --work-tree=~/.local/src/st remote set-url origin git@github.com:$(whoami)/st
  sudo make -sC ~/.local/src/st install
}

setup_dmenu() {
  echo -e "${blue}DMENU${normal}"
  git clone --depth=1 https://github.com/ghoulboii/dmenu ~/.local/src/dmenu
  git --git-dir=~/.local/src/dmenu/.git --work-tree=~/.local/src/dmenu remote set-url origin git@github.com:$(whoami)/dmenu
  sudo make -sC ~/.local/src/dmenu install
}

setup_neovim() {
  echo -e "${blue}NEOVIM${normal}"
  git clone --depth=1 https://github.com/ghoulboii/nvim ~/.config/nvim
  git --git-dir=~/.config/nvim/.git --work-tree=~/.config/nvim remote set-url origin git@github.com:$(whoami)/nvim
}

install_packages() {
  echo -e "\${blue}PACKAGES\${normal}"
  local packages=(
    acpi
    bat
    btop
    deno
    easyeffects
    exa
    fastfetch
    fd
    feh
    firefox
    fzf
    jdk8-openjdk
    jdk17-openjdk
    gamemode
    gimp
    gparted
    lf
    libqalculate
    man-db
    mesa
    mpv
    mpv-mpris
    ncdu
    neovim
    newsboat
    noto-fonts
    noto-fonts-emoji
    npm
    obs-studio
    openssh
    os-prober
    pavucontrol
    pacman-contrib
    pcmanfm-gtk3
    pipewire
    pipewire-pulse
    playerctl
    prismlauncher-bin
    python-pywal
    qbittorrent
    qt5-styleplugins
    qt6gtk2
    reflector
    ripgrep
    rose-pine-gtk-theme
    socat
    tldr
    tmux
    trash-cli
    ttf-firacode-nerd
    ttf-ms-fonts
    ueberzugpp
    wget
    wine-staging
    winetricks
    wireplumber
    xbindkeys
    xclip
    xdg-desktop-portal-gtk
    xdotool
    xf86-input-libinput
    xorg-xev
    xorg-xinput
    xorg-xrandr
    xorg-xset
    xsel
    yt-dlp
    zathura
    zathura-pdf-mupdf
    zoxide
    zsh-autosuggestions
    zsh-completions
    zsh-fast-syntax-highlighting
    zsh-history-substring-search
    zstd
  )
  arch-chroot /mnt sudo -i -u "$username" paru -Sy --noconfirm --needed "${packages[@]}"
}

main() {
  # If -q or --quiet,
  # If --suckless, install all suckless packages
  # If --paru, installs paru
  case
}
main "$@"
