# Commit message template (Scoped Commits)

```text
<scope>: <description>

<What changed.>
<Why it changed.>
```

> Notes:
>
> - `<scope>` is the subsystem, area, or module touched (e.g. `auth`, `cli`,
>   `parser`, `lazyvim`). Pick one — it is required, not optional.
> - Multi-scope commit: use a broader scope that covers them, comma-separate
>   (`auth, billing`), or `treewide`/`all`/`global` if the whole tree is touched.
> - Ticket numbers go in the body, as a footer, or in parentheses after the scope
>   (`auth (PROJ-123): fix login bug`).
> - Keep the description imperative and specific ("Add", "Fix", "Remove",
>   "Refactor"). The description should make the type obvious on its own.
> - Avoid implementation minutiae; focus on behavior and intent.
> - Reverts, merges, and other special commits may follow Git's default format.