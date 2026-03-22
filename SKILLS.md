# Dotfiles — AI Context

This file describes the full architecture of this dotfiles repo so any AI assistant can pick up where the last session left off.

## Overview

Portable dotfiles managed with **GNU Stow**, supporting **macOS**, **Debian-based Linux** (Ubuntu, Pop!_OS), and **WSL**. The repo lives at `~/dotfiles` (GitHub: `Islamsulaiman/dotfiles`).

## Repo Structure

```
dotfiles/
  install.sh                  # Entry point: detects OS, sources scripts, prints failure summary
  uninstall.sh                # Tears down everything for clean re-runs (confirms before acting)
  scripts/
    packages-macos.sh         # brew install for macOS
    packages-debian.sh        # apt + GitHub releases for Debian/WSL
    setup-common.sh           # Cross-platform: oh-my-zsh, plugins, tpm, asdf, stow, node, cspell
  .stow-local-ignore          # Excludes non-config files from stow (scripts/, install.sh, etc.)
  .tool-versions              # asdf: nodejs 22.7.0
  bash/.bashrc                # Standard Debian bashrc + asdf + fzf
  zsh/.zshrc                  # Oh My Zsh with robbyrussell theme + custom plugins
  vim/.vimrc                  # Minimal: system clipboard only
  tmux/.tmux.conf             # catppuccin, vim-tmux-navigator, floax, resurrect, continuum
  nvim/.config/nvim/          # LazyVim config (imported via git subtree)
  nvim-custom/.config/nvim/   # Old custom nvim config (backup, not stowed by default)
  cspell.json                 # Spell checking config
```

## How Stow Works Here

Each top-level directory is a stow "package." Running `stow nvim` creates a symlink `~/.config/nvim -> ~/dotfiles/nvim/.config/nvim`.

**Stow packages:** `bash`, `zsh`, `vim`, `tmux`, `nvim`. The `nvim-custom` package targets the same directory as `nvim` — only one can be stowed at a time.

**Stow flags used:** `stow -v -d "$DOTFILES_DIR" -t "$HOME" --adopt <pkg>`
- `--adopt` moves any existing target file into the package dir, then creates the symlink. This handles conflicts like Oh My Zsh creating its own `~/.zshrc`.
- `git checkout -- .` runs after stow to restore the repo's versions (discarding whatever was adopted).
- `--restow` is NOT used — it causes failures when target files are regular files instead of existing symlinks.
- `-d` and `-t` use absolute paths to avoid WSL's `BUG in find_stowed_path` errors with `/mnt/c/` mount points.
- `mkdir -p ~/.config` runs before stowing to prevent stow from symlinking the entire `.config` directory.

## Install Script Architecture

`install.sh` defines shared helpers (`info`, `ok`, `warn`, `error`) and a `FAILURES` array. Every `warn()` call appends to `FAILURES`. At the end, `print_summary()` prints a numbered list of all failures. Scripts are `source`d (not executed) so they share the helpers and FAILURES array.

```
install.sh
  ├── source packages-macos.sh   (if Darwin)
  ├── source packages-debian.sh  (if Linux + /etc/debian_version)
  └── source setup-common.sh     (always)
```

**No `set -euo pipefail`** — each step uses `|| warn` so failures are logged but don't kill the script.

### packages-macos.sh

Installs Homebrew if missing, then `brew install` for: git, zsh, neovim, tmux, fzf, ripgrep, fd, lazygit, lazydocker, gh, stow, curl, asdf. Per-package error handling with `|| warn`.

### packages-debian.sh

1. `sudo apt update` + `sudo apt install` for: git, zsh, tmux, fzf, ripgrep, fd-find, stow, curl, xclip, build-essential, keychain
2. Verifies critical packages are available post-install
3. Installs from **GitHub releases** (apt versions are too old or unavailable): neovim, lazygit, lazydocker
4. Creates `fd` symlink for `fdfind` (Debian naming)
5. Fixes broken Docker completion symlink on WSL (`/usr/share/zsh/vendor-completions/_docker`)
6. Installs GitHub CLI from official apt repo

### setup-common.sh

Runs on all platforms, in order:
1. Sets zsh as default shell (`chsh`)
2. Installs Oh My Zsh (unattended)
3. Clones zsh plugins into oh-my-zsh custom dir: zsh-autosuggestions, zsh-syntax-highlighting, zsh-vi-mode
4. Installs TPM (tmux plugin manager)
5. Installs asdf v0.15.0 (brew on macOS, git clone on Linux). Adds `$ASDF_DIR/bin` AND `$ASDF_DIR/shims` to PATH — does NOT source `asdf.sh` (causes control flow issues in sourced scripts)
6. Stows dotfile packages (bash, zsh, vim, tmux, nvim)
7. Installs Node.js 22.7.0 via asdf
8. Installs cspell via npm
9. Installs gh-dash extension (requires prior `gh auth login`)

## Uninstall Script

`uninstall.sh` confirms before acting, then removes:
- Stow symlinks (`stow -D`)
- `~/.oh-my-zsh`, `~/.tmux/plugins`, `~/.asdf`
- `~/.zcompdump*` cache files
- gh-dash extension
- On Linux only: GitHub-release binaries from `/usr/local/bin/` (nvim, lazygit, lazydocker) and `/opt/nvim-linux-x86_64/`, plus the fd symlink if present

Does NOT remove: system packages (apt/brew), the repo itself, git config, SSH keys.

## Key Config Files

### zsh/.zshrc

- **Theme:** robbyrussell (NOT powerlevel10k)
- **Plugins:** git, z, zsh-autosuggestions, zsh-syntax-highlighting, zsh-vi-mode
- **asdf:** Sources `$HOME/.asdf/asdf.sh` for shell integration; adds shims to PATH
- **Docker fix:** Removes `/usr/share/zsh/vendor-completions` from fpath if `_docker` is a broken symlink (WSL/Pop!_OS)
- **SSH:** macOS uses `ssh-add --apple-use-keychain`; Linux uses `keychain`
- **pybritive:** Completion sourced conditionally (`[[ -f ... ]] && source`)

### tmux/.tmux.conf

- **Prefix:** Ctrl-b
- **Plugins:** catppuccin (theme), vim-tmux-navigator, floax (floating pane), resurrect, continuum
- **Clipboard:** Platform-aware — pbcopy on macOS, xclip on Linux
- **Vi mode** in copy mode

### nvim/.config/nvim/

LazyVim-based config imported via git subtree (full commit history preserved). Plugin files: ui, spelling, ruby-lsp, navigation, git. Custom keymaps, options, and autocmds in `lua/config/`.

## Design Decisions

- **No `set -euo pipefail`:** Originally used, but it silently killed the script on first failure. Now every step is resilient with `|| warn` fallbacks.
- **`--adopt` without `--restow`:** `--restow` does unstow-then-stow; the unstow phase fails when targets are regular files (e.g., Oh My Zsh's `~/.zshrc`). `--adopt` alone handles both first-run and re-run cases.
- **asdf: PATH instead of sourcing:** Sourcing `asdf.sh` inside a `source`d script can cause `return` to exit the calling script's context. Adding `$ASDF_DIR/bin:$ASDF_DIR/shims` to PATH is sufficient for the install script.
- **Parallel arrays for zsh plugins:** `declare -A` (associative arrays) requires bash 4+; macOS ships bash 3.2. Parallel indexed arrays work everywhere.
- **Ruby deferred:** Ruby is NOT installed by the script — manual setup later.
- **Cursor trailer disabled:** Do NOT add `--trailer` to git commits.

## Platform-Specific Notes

### macOS
- All tools via Homebrew (including asdf)
- Xcode CLI tools needed for treesitter
- `/opt/homebrew/bin/brew` for Apple Silicon

### Debian/Ubuntu/Pop!_OS
- neovim, lazygit, lazydocker from GitHub releases (apt versions too old/missing)
- `fd-find` package → `fdfind` binary → `/usr/local/bin/fd` symlink
- `keychain` for SSH agent persistence
- `xclip` for tmux clipboard
- GitHub CLI from official apt repo (not apt default)

### WSL
- Stow sees `/mnt/c/` mount points and prints `BUG in find_stowed_path` — fixed by using absolute paths with `-d` and `-t` flags
- Docker Desktop may create a broken `_docker` completion symlink — handled in both `packages-debian.sh` (removes it) and `.zshrc` (filters fpath)
- `touch` on a broken symlink fails with "No such file or directory" — must `rm` the symlink first, then `touch`

## Testing Workflow

The development loop on the VM/WSL:
```bash
./uninstall.sh    # clean slate (confirms first)
./install.sh      # reinstall everything
# Check the failure summary at the end
# Fix issues, commit, push, pull on VM, repeat
```

## Files to Exclude from Stow

Controlled by `.stow-local-ignore` (regex patterns):
```
\.git, \.github, \.gitignore, \.stow-local-ignore, \.ruby-lsp,
\.tool-versions, README\.md, LICENSE, cspell\.json, scripts,
install\.sh, uninstall\.sh
```
