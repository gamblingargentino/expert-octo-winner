# HUNT OR DIE

Session-based co-op journey roguelite. Roblox. Two devs.

Each server is one journey. You leave Greyhaven, push outward, go deeper for
better cargo, and the journey ends when the party wipes. Nothing persists but
cosmetics. The game asks one question, over and over: **deeper?**

Full design lives in the Obsidian vault. Build order lives in
`06 Production/Development Roadmap`. This file is the repo contract only.

## First-time setup

```powershell
aftman install          # pins rojo, selene, stylua for both devs
.\build.ps1             # generates place\HuntOrDie.rbxl from src/
.\serve.ps1             # live-sync; leave running while you work
```

Then in Studio: open `place\HuntOrDie.rbxl`, install the Rojo plugin, **Connect**.
Press Play — output should read `[HuntOrDie] server up`.

Code lives in Git. Studio is a viewport onto it.

> `build.ps1` regenerates the place file and will refuse to overwrite an
> existing one, because once Dev A puts geometry in there it is the only copy.
> After that point use `serve.ps1` only.

## Checks

```powershell
stylua src              # format (CI checks this)
selene src              # lint
rojo build -o build.rbxl  # proves the project still maps
```

CI runs all three on every push and PR.

## The rule that keeps this repo mergeable

**`.rbxl` is a binary blob. Two people cannot merge one.** If both devs edit the
place file, one person's day is simply gone — no conflict markers, no recovery.
So:

| Lives in Git | Lives in the place file |
|---|---|
| All code (`src/`) | World geometry, lighting, terrain |
| Both devs edit freely | **Dev A only** |

`*.rbxl` is gitignored for this reason. Do not remove it from `.gitignore`.
Dev A shares the place file out of band when geometry changes.

## Who owns what

| Dev A — feel | Dev B — journey |
|---|---|
| `src/client/` | `src/server/` |
| First person, gun, creatures | Journey state machine, depth |
| Graybox world, Greyhaven | Cargo, harvest lock, forward-spend |
| Horror pass (light, audio) | Spawn budget, death/spectate/wipe |

Dev A never edits `src/server/`. Dev B never opens the place file.
`src/shared/` is the seam — change it by agreement, never silently.

## The seam

`src/shared/Remotes.lua` is the contract. Both halves code against it and
nothing else. `src/shared/Config.lua` holds every tuning knob, including the
two numbers that decide whether the game works at all:

- `DEPTH_SPAWN_BUDGET` — does going deeper actually get worse?
- `BAND_1_YIELD` — does camping the outskirts run dry?

If playtesters don't want to go deeper, the fix is in those two values. It is
not in more creatures, bosses, or atmosphere.

## Workflow

```sh
git switch -c feat/<thing>
# work
stylua src && selene src
git commit
git push -u origin feat/<thing>
```

Merge to `main` and playtest together at least twice a week. The seam rots
silently; playing is the only way to find out.
