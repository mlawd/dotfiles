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

o() {
  local port
  port=$(jot -r 1 49152 65535)
  OPENCODE_PORT="$port" \
  opencode --port "$port" "$@"
}

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
    git worktree add ".wt/$1" "$2" && cd ".wt/$1"
  elif [[ $# -eq 1 ]]; then
    git worktree add ".wt/$1" "$1" && cd ".wt/$1"
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
  if [[ $# -eq 0 ]]; then
    echo "usage: st <branch-name>" >&2
    return 1
  fi

  wt=".wt/$1"

  echo $wt

  local branch="${2:-main}"

  git worktree add "$wt" "$branch" -f

  cd "$wt"
}

eval "$(zellij setup --generate-auto-start zsh)"

# =============================================================================
# Zellij: rename the current tab on cd (git-repo aware)
#   - inside a repo:      repo root name        (~/dotfiles/scripts -> dotfiles)
#   - inside a worktree:  repo:worktree         (~/dotfiles/.wt/feat-x -> dotfiles:feat-x)
#   - otherwise:          last path segment
# =============================================================================
zellij_tab_name() {
  emulate -L zsh
  local name top gdir cdir
  local -a info
  info=("${(@f)$(git rev-parse --show-toplevel --git-dir --git-common-dir 2>/dev/null)}")
  if [[ -n "${info[1]}" ]]; then
    top=${info[1]}
    gdir=${info[2]:A}
    cdir=${info[3]:A}
    if [[ "$gdir" != "$cdir" ]]; then
      name="${cdir:h:t}:${top:t}"   # linked worktree
    else
      name="${top:t}"               # main working tree
    fi
  else
    name="${PWD:t}"                  # not a git repo
  fi
  command zellij action rename-tab "$name" 2>/dev/null
}

if [[ -n "$ZELLIJ" ]]; then
  autoload -U add-zsh-hook
  add-zsh-hook chpwd zellij_tab_name
  zellij_tab_name   # set for the initial directory
fi

# =============================================================================
# Local overrides (machine-specific config, secrets, project aliases)
# Loaded last so it can override anything above
# =============================================================================
[[ -f "$HOME/.local.zshrc" ]] && source "$HOME/.local.zshrc"

# bun completions
[ -s "/Users/mlawd/.bun/_bun" ] && source "/Users/mlawd/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> oh-my-opencode-slim background subagents >>>
export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
# <<< oh-my-opencode-slim background subagents <<<
