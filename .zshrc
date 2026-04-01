# =============================================================================
# Homebrew (must be first — other tools depend on brew-installed binaries)
# =============================================================================
eval "$(/opt/homebrew/bin/brew shellenv)"

# =============================================================================
# Oh My Zsh
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)

# fpath additions (before oh-my-zsh runs compinit)
# OPENSPEC: completions — if openspec regenerates its block, merge the fpath line here
fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)
fpath+=("/opt/homebrew/share/zsh/site-functions")

source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# Prompt (pure)
# =============================================================================
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color 107
prompt pure

# =============================================================================
# Environment
# =============================================================================
export VISUAL=nvim
export EDITOR="$VISUAL"
export FZF_DEFAULT_COMMAND='ag --hidden --ignore-dir .git --ignore-dir node_modules --ignore-dir .serverless --ignore-dir android -p ~/.gitignore -g "" --ignore package-lock.json'

# =============================================================================
# PATH
# =============================================================================
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$HOME/Library/Android/sdk:$PATH"

# =============================================================================
# Version manager (asdf)
# =============================================================================
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

# =============================================================================
# Aliases
# =============================================================================
alias n='nvim'
alias dfs='cd ~/dotfiles'
alias creds='n ~/.aws/credentials'
alias orc='n ~/.config/opencode/opencode.json'
alias cc='n ~/.claude/settings.json'

# git
alias git-pretty='git log --all --graph --decorate --oneline --simplify-by-decoration'
alias gca='git commit --amend --no-edit'
alias gpf='git push --force-with-lease'

# unalias oh-my-zsh git plugin conflicts
unalias gwt 2>/dev/null

# =============================================================================
# Functions
# =============================================================================

# edit & source zshrc / local overrides
zrc() { n ~/.zshrc && source ~/.zshrc; }
lcl() { n ~/.local.zshrc && source ~/.local.zshrc; }

# mkdir & cd
cdf() { mkdir -p "$1" && cd "$1"; }

# git: fuzzy checkout branch
co() {
  local branch
  branch=$(git branch | fzf)
  [[ -n "$branch" ]] && git checkout "$(echo "$branch" | tr -d '[:space:]')"
}

# git: fuzzy open changed file & optionally stage
gcon() {
  local full_file file answer
  full_file=$(git status -s | fzf)
  [[ -z "$full_file" ]] && return

  file="${full_file:3}"
  [[ -z "$file" ]] && return

  n "$file"

  echo "Stage this file? [y/N]"
  read -r answer
  [[ "$answer" == "y" ]] && git add "$file"
}

# git: re-apply .gitignore to tracked files
g-forget() {
  git rm -r --cached .
  git add .
}

# git: fuzzy delete branches
gbc() {
  local branches
  branches=$(git branch | fzf -m)
  [[ -n "$branches" ]] && git branch -d $(echo "$branches")
}

# git: worktree management
gwt() {
  if [[ $# -eq 2 ]]; then
    git worktree add "$1" "$2" && cd "$1"
  elif [[ $# -eq 1 ]]; then
    git worktree add "$1" && cd "$1"
  else
    local wt
    wt=$(git worktree list | fzf)
    [[ -n "$wt" ]] && cd "$(echo "$wt" | awk '{print $1}')"
  fi
}

gwtd() {
  local wt dir
  wt=$(git worktree list | fzf)
  if [[ -n "$wt" ]]; then
    dir=$(echo "$wt" | awk '{print $1}')
    git worktree remove "$dir"
  fi
}

st() {
  wt=".wt/$1"

  echo $wt

  git worktree add "$wt" main -f

  cd "$wt"
}

# =============================================================================
# Local overrides (machine-specific config, secrets, project aliases)
# Loaded last so it can override anything above
# =============================================================================
[[ -f "$HOME/.local.zshrc" ]] && source "$HOME/.local.zshrc"
