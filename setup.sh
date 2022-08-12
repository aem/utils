################################################################################
### Link dotfiles to correct location                                        ###       
################################################################################
ln -sf ~/git/aem/utils/vimrc ~/.vimrc
ln -sf ~/git/aem/utils/zshrc ~/.zshrc
ln -sf ~/git/aem/utils/gitignore ~/.gitignore
ln -sf ~/git/aem/utils/gitconfig ~/.gitconfig
ln -sf ~/git/aem/utils/karabiner.json ~/.config/karabiner/karabiner.json

################################################################################
### Install third-party software                                             ###       
################################################################################
# Homebrew
brew -v > /dev/null 2> /dev/null
if [ "$?" -ne "0" ]; then
    sudo -p "Homebrew installation requires sudo -- please enter your local machine password: " /usr/bin/true
    set -e
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    set +e
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Brew package isntalls
brew install --cask sequel-ace
brew install --cask jasper
brew install --cask jetbrains-toolbox
brew install --cask 1password
brew install --cask karabiner-elements
brew install --cask rocket
brew install --cask beardedspice
brew install --cask spectacle
brew install --cask fantastical
brew install --cask spotify
brew install --cask firefox
brew install --cask slack
brew install --cask kap
brew install --cask discord
brew install --cask loom
brew install --cask visual-studio-code
brew install node
brew install yarn
brew install git --force

# npm installs
npm i -g n
n latest


# I will always forget this stuff
echo "Don't forget to install third-party things you'll want!"
echo "  - Bear (Mac App Store)" 

################################################################################
### Set up system defaults                                                   ###       
################################################################################
source ~/.zshrc
defaults write com.apple.Finder AppleShowAllFiles YES
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows YES

# ensure golinks work in firefox
for dir in $HOME/Library/Application\ Support/Firefox/Profiles/*/
do
  dir=${dir%*/}
  echo "user_pref(\"browser.fixup.domainwhitelist.go\", true);" >> "$dir/user.js";
  echo "user_pref(\"security.tls.enable_0rtt_data\", false);" >> "$dir/user.js";
  echo "user_pref(\"security.tls.hello_downgrade_check\", false);" >> "$dir/user.js";
done
