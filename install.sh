#!/bin/bash

# Get the directory where the script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to create symlink
create_symlink() {
    local src=$1
    local dest=$2

    # Check if destination exists
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        # If it's already a symlink to the correct file, skip
        # Use readlink -f on both sides to ensure absolute path comparison
        if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
            echo "Skipping $dest, already linked."
            return
        fi
        
        # Backup existing file with timestamp to ensure idempotency
        local backup_name="${dest}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing $dest to $backup_name"
        mv "$dest" "$backup_name"
    fi

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"

    # Create symlink
    echo "Linking $src to $dest"
    ln -s "$src" "$dest"
}

echo "Starting dotfiles installation..."

# Git
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Tmux
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Vim
create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/vim/.vim" "$HOME/.vim"

# Zsh
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Configs (handling contents of config/.config)
if [ -d "$DOTFILES_DIR/config/.config" ]; then
    for config_path in "$DOTFILES_DIR/config/.config"/*; do
        config_name=$(basename "$config_path")
        create_symlink "$config_path" "$HOME/.config/$config_name"
    done
fi

# --- Environment Setup ---

echo "Starting environment setup..."

# 2. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Change default shell to zsh
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Changing default shell to zsh..."
        chsh -s "$(which zsh)"
    fi
else
    echo "Oh My Zsh already installed."
fi

# 3. Install Miniconda
if [ ! -d "$HOME/miniconda3" ]; then
    echo "Installing Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p "$HOME/miniconda3"
    rm miniconda.sh
    # Note: Conda initialization is handled in .zshrc
else
    echo "Miniconda already installed."
fi

echo "Dotfiles installation and environment setup complete!"

