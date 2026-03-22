# My Dotfiles

Portable dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/), supporting **macOS**, **Debian-based Linux** (Ubuntu, Pop!_OS), and **WSL**.

## Quick Start

```bash
git clone git@github.com:Islamsulaiman/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:

1. Detect your OS (macOS or Debian-based Linux)
2. Install all system packages via `brew` or `apt` (+ GitHub releases on Debian)
3. Set up Oh My Zsh, zsh plugins, TPM, and asdf
4. Stow all config packages into your home directory
5. Install Node.js via asdf, then cspell via npm

A failure summary is printed at the end showing any steps that failed.

## Uninstall

To tear everything down for a clean re-run:

```bash
./uninstall.sh
```

This removes stow symlinks, Oh My Zsh, TPM, asdf (and all runtimes), zsh cache, gh-dash, and GitHub-release binaries on Linux. It does NOT remove system packages, the repo, git config, or SSH keys.

## Packages

Each top-level directory is a stow package. Run `stow <package>` to symlink it.

| Package | What it configures |
|---|---|
| `bash` | `.bashrc` with asdf and fzf integration |
| `zsh` | `.zshrc` with Oh My Zsh, robbyrussell theme, zsh-vi-mode, autosuggestions, syntax highlighting |
| `vim` | `.vimrc` with system clipboard |
| `tmux` | `.tmux.conf` with catppuccin theme, vim-tmux-navigator, floax, resurrect, continuum |
| `nvim` | LazyVim-based neovim config with custom keymaps, git integrations, and ruby-lsp |
| `nvim-custom` | Previous custom neovim config (backup, not stowed by default) |

## Manual Stow Usage

```bash
cd ~/dotfiles

stow nvim          # symlink LazyVim config to ~/.config/nvim/
stow -D nvim       # remove the symlink
stow nvim-custom   # switch to old custom nvim config instead
```

Only one of `nvim` or `nvim-custom` can be stowed at a time since they target the same directory.

## Post-Install

After running `install.sh`:

1. Log out and back in (or run `exec zsh`) to load the shell config
2. Open tmux and press `prefix + I` (Ctrl-b then I) to install tmux plugins
3. Open nvim — lazy.nvim auto-installs all plugins on first launch
4. Run `gh auth login` to authenticate GitHub CLI, then gh-dash will work

## Dependencies

Installed automatically by `install.sh`:

**System packages:** git, zsh, neovim, tmux, fzf, ripgrep, fd, lazygit, lazydocker, gh, stow, curl, xclip (Linux), build-essential (Linux), keychain (Linux)

**Frameworks:** Oh My Zsh, zsh-autosuggestions, zsh-syntax-highlighting, zsh-vi-mode, TPM, asdf

**Via asdf:** Node.js 22.7.0

**Via npm:** cspell

**Via gh:** gh-dash (requires `gh auth login` first)

## AI Context

See [SKILLS.md](SKILLS.md) for a detailed architecture reference designed for AI assistants working on this repo.
