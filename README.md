# HUNT OR DIE

Session-based co-op journey roguelite. Roblox. Two devs.

Each server is one journey. You leave Greyhaven, push outward, go deeper for
better cargo, and the journey ends when the party wipes. Nothing persists but
cosmetics. The game asks one question, over and over: **deeper?**

Full design lives in the Obsidian vault. Build order lives in
`06 Production/Development Roadmap`. This file is the repo contract only.

## First-time setup

Each dev does this once, on their own machine.

```powershell
git clone https://github.com/gamblingargentino/expert-octo-winner.git
cd expert-octo-winner
aftman install          # rojo, selene, stylua — pinned versions, same for both devs
rojo plugin install     # installs the Rojo plugin into Studio
.\build.ps1             # generates place\HuntOrDie.rbxl from src/
```

Then every working session:

```powershell
.\serve.ps1             # leave running
```

In Studio: open `place\HuntOrDie.rbxl` → Plugins tab → **Rojo** → **Connect**
(defaults to `localhost:34872`). Press Play — output should read
`[HuntOrDie] server up`.

Edit a file in VS Code, save, and it appears in Studio instantly.

> [!NOTE]
> **Rojo does not sync the two of you to each other.** It only bridges your own
> disk to your own Studio. Git is what connects the two devs. You each run your
> own `rojo serve` against your own clone — nothing is shared over the network.

### The place file, and why only one of you owns it

`place/HuntOrDie.rbxl` is gitignored, so a fresh clone has no place file —
`build.ps1` generates one from `src/`. That is all Dev B ever needs: a throwaway
shell to run code in, regenerable any time.

Dev A's copy is different. Once world geometry goes into it, that file is the
only copy in existence and cannot be merged or regenerated. So:

- **Dev B** — regenerate freely with `build.ps1`. Never ask for Dev A's file.
- **Dev A** — never run `build.ps1` again after adding geometry (it refuses, but
  don't rely on that). Back the file up somewhere that isn't this repo.

### Playtesting together

Two ways, in order of how often you will want them:

1. **Solo, in Studio** — Test tab → Players: 2 → **Start**. Runs a local server
   with two clients. Covers almost everything: cargo races, death, spectate.
2. **Together, over the internet** — Dev A publishes the place to Roblox
   (File → Publish to Roblox), both join from the client. Needed for real
   latency and real network conditions. Do this before the gate, not after.

For option 2 only Dev A's place matters, which is another reason geometry lives
with one person.

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
