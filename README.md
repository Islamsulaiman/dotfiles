# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on your system

### Git

```
sudo apt install git
```

### tmux
```
sudo apt install tmux
```

### neovim
```

```

### zsh
```

```

### Stow

```
sudo apt install stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git

```
$ git clone git@github.com:Islamsulaiman/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow . # to stow all the packages at once.
$ stow <package name> # e.g. stow nvim, to install sperate pacakge
```
