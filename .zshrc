# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# pure prompt
# fpath+=('/home/mld/.npm-global/lib/node_modules/pure-prompt/functions')

FILE="$HOME/.local.zshrc"
if test -f "$FILE"; then
  source "$FILE"
  else
	  echo "Does not exist"
fi

autoload -U promptinit; promptinit
zstyle :prompt:pure:path color 107

ZSH_THEME=""

alias n='nvim'

# edit & source zshrc
zrc(){
  WD=$(pwd);
  n ~/.zshrc
  source ~/.zshrc
  cd $WD
}

alias vrc='n ~/.config/nvim/init.vim'

# cd /mnt/c/projects

# default editor
export VISUAL=nvim
export EDITOR="$VISUAL"

# ag ignores
if type ag &> /dev/null; then
	export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi

# git alias'
alias git-pretty='git log --all --graph --decorate --oneline --simplify-by-decoration'
alias gca='git commit --amend --no-edit'

gbc() {
  git branch -D $(git branch | fzf -m)
}

git-conflict() {
  FILE=$(git status --porcelain | grep ^UU | fzf)
  echo ${FILE:3}
}

# mkdir & cd
cdf () {
  mkdir $1 && cd $1
}

co() {
  branch=$(git branch | fzf)

  if [[ -n "$branch" ]]; then
    bnw="$(echo -e "${branch}" | tr -d '[:space:]')"
    git checkout $bnw
  fi
}

plugins=()
source $ZSH/oh-my-zsh.sh
prompt pure

. $HOME/.asdf/asdf.sh
