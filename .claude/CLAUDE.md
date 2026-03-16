## Planning

Before implementing a multi-step task, write the plan to `PLAN.md` in the project root and work against it.

## Communication

When I say "show me" a file or code, print the content in a code block in your response so I can see it. Don't just read it silently with the Read tool.

## Dotfiles

`~/.claude/CLAUDE.md` is a symlink to `~/workspace/dotfiles/.claude/CLAUDE.md`. When committing changes to this file, commit and push from `~/workspace/dotfiles`.

## Database

Never run any database operation that could take more than 2 seconds without first confirming with me. This applies to ALL databases (PostgreSQL, RethinkDB, etc). If you're unsure whether a query will be fast, ask first. Examples of slow operations:
- RethinkDB: `.filter()` is a full table scan — use `.get()` or secondary index queries only
- PG: ORDER BY or WHERE on non-indexed columns on large tables
- PG: COUNT(*) on large tables
- PG: GREATEST() across multiple columns without indexes
- Any query without a primary key or index lookup on a large table

## Git

When pulling or integrating branches, use merge (not rebase). For example, `git pull origin main --no-rebase`.
