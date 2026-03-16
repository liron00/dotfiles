#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$1"

  if [ -L "$dest" ]; then
    echo "already linked: $1"
    return
  fi

  if [ -e "$dest" ]; then
    echo "backing up:     $1 -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "linked:         $1"
}

# Shell
link .zshrc
link .zprofile

# Claude Code
link .claude/settings.json
link .claude/CLAUDE.md

echo ""
echo "Done!"
