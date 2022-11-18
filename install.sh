echo "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing FZF"
brew install fzf
echo "Installing rectangle"
brew install --cask rectangle
echo "Installing zsh"
brew install zsh
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Installing AG"
brew install the_silver_searcher
echo "Installing nvim"
brew install neovim
echo "Installing ASDF"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
echo "Installing stow"
brew install stow
echo "Installing lazygit"
brew install lazygit

echo "Cloning dotfiles"
git clone https://github.com/mlawd/dotfiles.git
mv ~/.zshrc ~/.zshrc_old
(cd dotfiles && stow -t ~ .)
source ~/.zshrc

echo "Installing Node"
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 16.18.0
asdf global nodejs 16.18.0

echo "Pure prommpt"
npm install --global pure-prompt
source ~/.zshrc

echo "Setup nvim"
vim +'PlugInstall --sync' +qa
vim +qa

echo "Updating default shell"
sh -c "echo $(which zsh) >> /etc/shells"
chsh -s $(which zsh)

