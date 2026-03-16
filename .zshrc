export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

# Added by Windsurf
export PATH="/Users/liron/.codeium/windsurf/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Ensure nvm-installed Claude Code takes precedence over cmux's bundled version
alias claude="$HOME/.nvm/versions/node/$(node -v)/bin/claude"
export PATH="$HOME/.local/bin:$PATH"

# cd into a worktree by issue number, e.g. cdi 26
# If the worktree doesn't exist yet, creates it and launches Claude Code
cdi() {
  local dir=~/workspace/relhero-issue-"$1"
  local main=~/workspace/relhero
  if [[ ! -d "$dir" ]]; then
    echo "Creating worktree for issue $1..."
    git -C "$main" fetch origin
    if git -C "$main" branch -a --list "*issue-$1*" | grep -q .; then
      git -C "$main" worktree add "$dir" "claude/issue-$1"
    else
      git -C "$main" worktree add -b "claude/issue-$1" "$dir" origin/main
    fi
    echo "Copying .env..."
    cp "$main/apps/api/.env" "$dir/apps/api/.env" 2>&1 || echo "FAILED: api .env"
    open -a "Fork" "$dir"
    cd "$dir"${2:+/apps/$2}
    [[ -n "$2" ]] && yarn install
    claude "/lgi $1"
  else
    cd "$dir"${2:+/apps/$2}
    [[ -n "$2" ]] && yarn install
  fi
}

# Clean up a worktree for a GitHub issue, e.g. dgi 26
dgi() {
  local N
  if [[ -n "$1" ]]; then
    N="$1"
  elif [[ "$(pwd)" =~ relhero-issue-([0-9]+) ]]; then
    N="${MATCH[1]}"
  else
    echo "Usage: dgi <issue-number>" >&2
    return 1
  fi
  cd ~/workspace/relhero
  git worktree remove ../relhero-issue-"$N"
  git branch -D claude/issue-"$N"
  echo "Cleaned up issue #$N"
}

# Prompt matching Claude Code status line
precmd() {
  local root branch repo rel
  root=$(/usr/bin/git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$root" ]]; then
    repo=${root:t}
    rel=${PWD#"$root"}
    branch=$(/usr/bin/git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
      PROMPT="/${repo}${rel} :${branch} $ "
    else
      PROMPT="/${repo}${rel} $ "
    fi
  else
    PROMPT="/${PWD:t} $ "
  fi
}
