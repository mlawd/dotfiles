# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# pure prompt
fpath+=('/home/mld/.npm-global/lib/node_modules/pure-prompt/functions')
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color 107

ZSH_THEME=""

# setup nvim because 0.4 ubuntu :(
alias n='~/squashfs-root/AppRun'

# edit & source zshrc
zrc(){
  WD=$(pwd);
  n ~/.zshrc
  source ~/.zshrc
  cd $WD
}

# wsl project specific stuff
alias projects='cd /mnt/c/projects'
cd /mnt/c/projects

# default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# ag ignores
if type ag &> /dev/null; then
	export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi

# git alias'
alias git-pretty='git log --all --graph --decorate --oneline --simplify-by-decoration'
alias gco='git checkout'

# mkdir & cd
cdf () {
  mkdir $1 && cd $1
}

plugins=()
source $ZSH/oh-my-zsh.sh
prompt pure
