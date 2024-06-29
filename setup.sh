#! /bin/sh

step () {
    final=$(echo "$@")
    plus=$(expr ${#final} + 6)

    printhashtags () {
        for i in $(seq $plus); do
            printf "#"
        done
    }

    echo
    printhashtags
    echo "\n## $@ ##"
    printhashtags
    echo
}

step "Installing xcode command line tools if not already installed"
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
    echo "Xcode CLI tools not found. Installing them..."
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l |
        grep "\*.*Command Line" |
        head -n 1 | awk -F"*" '{print $2}' |
        sed -e 's/^ *//' |
        tr -d '\n')
    softwareupdate -i "$PROD" -v;
else
    echo "'xcode command line tools' is already installed, you're set."
fi

step "Installing brew if not already installed"
if ! command -v brew &> /dev/null
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "brew is already installed, you're set."
    sleep 1
fi

install () {
    if ! command -v "$@" &> /dev/null; then
        brew install "$@"
    else
        echo "'$@' is already installed, you're set."
        sleep 1
    fi
}

step "Installing dependencies/apps/sketchybar if not already installed."
brew tap FelixKratz/formulae
install sketchybar

step "Installing dependencies/apps/borders if not already installed."
install borders

step "Tapping koekeishiya repo"
brew tap koekeishiya/formulae

step "Installing dependencies/apps/yabai if not already installed"
install yabai

step "Installing dependencies/apps/skhd if not already installed"
install skhd

step "Installing dependencies/apps/kitty if not already installed"
install --cask kitty

step "Installing dependencies/apps/jq if not already installed."
install jq

step "Installing dependencies/apps/btop if not already installed."
install btop

step "install wget"
install wget

step "Installing dependencies/shell/oh-my-zsh"
cd ~/
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh --unattended
rm -rf install.sh

step "Installing dependencies/shell/starship if not already installed"
install starship

step "Tapping fonts repo"
brew tap homebrew/cask-fonts

step "Installing dependencies/fonts/hack-nerd-font"
brew install font-hack-nerd-font

step "Installing dependencies/fonts/sf-symbols-mono"
brew install --cask font-sf-mono

step "Installing dependencies/fonts/fira-code"
brew install --cask font-fira-code

step "Installing dependencies/fonts/symbols-only-nerd-font"
brew install --cask font-symbols-only-nerd-font

step "Installing dependencies/fonts/sf-symbols"
brew install --cask sf-symbols

step "Cloning the dotfiles repository"
git clone git@github.com:QuakeWang/dotfiles.git 

step "Moving everything to the right place"
cd dotfiles
for dir in btop fastfetch kitty nvim sketchybar skhd yabai; do
    mkdir -p ~/.config/$dir
    cp -rf $dir/* ~/.config/$dir
    echo "Moved $dir"
done
cp starship/starship.toml ~/.config/starship.toml
echo "Moved starship"

step "Hiding Dock and menu bar"
read -p "Is your dock currently hidden? (y/n)" dock_hide
if [ $dock_hide == "n" ]; then
    osascript -e "tell application \"System Events\" to set the autohide of the dock preferences to true"
fi

read -p "Is your menu bar currently hidden? (y/n)" menu_hide
if [ $menu_hide == "n" ]; then
    osascript -e 'tell application "System Events"
    tell dock preferences to set autohide menu bar to not autohide menu bar
    end tell'
fi

# start yabai
yabai --start-service

# start skhd
skhd --start-service

# start sketchybar
brew services start sketchybar

# start borders
brew services start borders

step "That's All, and enjoy it!"
