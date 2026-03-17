# My Dotfiles

Portable dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/), supporting **macOS** and **Debian-based Linux** (Ubuntu, Pop!_OS, etc.).

## Quick Start

```bash
git clone git@github.com:Islamsulaiman/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:

1. Detect your OS (macOS or Debian-based Linux)
2. Install all system packages via `brew` or `apt`
3. Set up Oh My Zsh, Powerlevel10k, TPM, and asdf
4. Stow all config packages into your home directory
5. Install Node.js, cspell, and gh-dash
6. Optionally install Ruby + ruby-lsp

## Packages

Each top-level directory is a stow package. Run `stow <package>` to symlink it.

| Package | What it configures |
|---|---|
| `bash` | `.bashrc` with asdf and fzf integration |
| `zsh` | `.zshrc` with Oh My Zsh, Powerlevel10k, and fzf |
| `vim` | `.vimrc` with system clipboard |
| `tmux` | `.tmux.conf` with catppuccin theme, vim-tmux-navigator, floax, resurrect |
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

1. Open a new terminal to load the shell config
2. Run `p10k configure` to set up the Powerlevel10k prompt
3. Open tmux and press `prefix + I` (Ctrl-b then I) to install tmux plugins
4. Open nvim — lazy.nvim auto-installs all plugins on first launch

## Dependencies

Installed automatically by `install.sh`:

**System packages:** git, zsh, neovim, tmux, fzf, ripgrep, fd, lazygit, gh, stow, curl, xclip (Linux), build-essential (Linux)

**Frameworks:** Oh My Zsh, Powerlevel10k, zsh-syntax-highlighting, TPM, asdf

**Via asdf:** Node.js 22.7.0

**Via npm:** cspell

**Via gh:** gh-dash

**Optional:** Ruby + ruby-lsp (prompted during install)
