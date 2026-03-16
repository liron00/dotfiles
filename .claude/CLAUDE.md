## Planning

Before implementing a multi-step task, write the plan to `PLAN.md` in the project root and work against it.

## Communication

When I say "show me" a file or code, print the content in a code block in your response so I can see it. Don't just read it silently with the Read tool.

## Dotfiles

`~/.claude/CLAUDE.md` is a symlink to `~/workspace/dotfiles/.claude/CLAUDE.md`. When committing changes to this file, commit and push from `~/workspace/dotfiles`.

## Git

When pulling or integrating branches, use merge (not rebase). For example, `git pull origin main --no-rebase`.
