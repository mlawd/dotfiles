# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

#pure prompt
fpath+=$HOME/.zsh/pure

FILE="$HOME/.local.zshrc"
if test -f "$FILE"; then
  source "$FILE"
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

lcl(){
  WD=$(pwd);
  n ~/.local.zshrc
  source ~/.local.zshrc
  cd $WD
}

alias creds='n ~/.aws/credentials'
alias vrc='n ~/.config/nvim/init.vim'
alias dfs='~/dotfiles'

export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
export PATH="$PATH:$HOME/Library/Android/sdk"

# cd /mnt/c/projects

# default editor
export VISUAL=nvim
export EDITOR="$VISUAL"


export FZF_DEFAULT_COMMAND='ag --hidden --ignore-dir .git --ignore-dir node_modules --ignore-dir .serverless --ignore-dir android -p ~/.gitignore -g "" --ignore package-lock.json'

# git alias'
alias git-pretty='git log --all --graph --decorate --oneline --simplify-by-decoration'
alias gca='git commit --amend --no-edit'
alias gpf='git push --force-with-lease'

gbc() {
  git branch -D $(git branch | fzf -m)
}

gcon() {
  FULL_FILE=$(git status -s | fzf)

  if [[ -n "$FULL_FILE" ]]; then
    FILE=${FULL_FILE:3}

    if [[ -n "$FILE" ]]; then
      n "$FILE"

      echo "Do you wish to commit? [y/N]"

      read COMMIT

      if [[ "$COMMIT" == "y" ]]; then
        git add "$FILE"
      fi
    fi
  fi


  # n ${FILE:3}
}

g-forget() {
  git rm -r --cached .
  git add .
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

plugins=(git)
source $ZSH/oh-my-zsh.sh
prompt pure

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(/opt/homebrew/bin/brew shellenv)"

