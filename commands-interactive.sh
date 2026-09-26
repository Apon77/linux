#!/bin/bash

# --- Helper Functions ---
# Prints headers for readability
print_header() {
    echo -e "\n========================================="
    echo -e "  $1"
    echo -e "========================================="
}

# Standard interactive prompt function
ask_proceed() {
    read -p "$1 (y/n): " choice
    case "$choice" in 
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

# --- Step 1: Base Oh My Zsh Framework ---
print_header "Step 1: Base Oh My Zsh Framework"
if ask_proceed "Do you want to install Oh My Zsh?"; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Skipping Oh My Zsh installation."
fi

# --- Step 2: Main Plugins Ecosystem ---
print_header "Step 2: Plugins Ecosystem"
if ask_proceed "Install Fish-like Autosuggestions plugin?"; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if ask_proceed "Install Up-Arrow Substring History Search plugin?"; then
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
fi

if ask_proceed "Install Syntax Highlighting plugin (Recommended)?"; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if ask_proceed "Install 'diff-so-fancy' for human-readable Git diffs?"; then
    git clone --recurse-submodules https://github.com/so-fancy/diff-so-fancy $HOME/.diff-so-fancy --depth=1
fi

# --- Step 3: Powerlevel10k UI Theme ---
print_header "Step 3: Powerlevel10k UI Theme"
if ask_proceed "Do you want to install the Powerlevel10k theme?"; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    echo "Downloading preset .p10k.zsh configuration..."
    curl -fsSL https://raw.githubusercontent.com/Apon77/linux/junk/.p10k.zsh > ~/.p10k.zsh
    
    # Configure theme inside the configuration file
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
else
    echo "Keeping your active Zsh theme configuration."
fi

# --- Step 4: Configuration Files (.zshrc patches) ---
print_header "Step 4: Configuration File Patches"
if ask_proceed "Apply custom plugins registry block to your ~/.zshrc file?"; then
    # Dynamically replaces default git array with the chosen plugins bundle
    sed -i 's/plugins=(git)/plugins=(git z command-not-found extract zsh-autosuggestions history-substring-search zsh-syntax-highlighting)/g' ~/.zshrc
    echo "Plugin block registration updated successfully."
fi

# --- Step 5: External Custom Configs Setup ---
print_header "Step 5: External Profiles & Shortcuts"
if ask_proceed "Download external scripts (easy, functions, aliases) and link them?"; then
    # Safeguard: creates directory layout if missing
    mkdir -p ~/linux

    echo "Downloading configuration files from remote mirror..."
    curl -fsSL https://raw.githubusercontent.com/Apon77/linux/junk/easy.zsh > ~/linux/easy.zsh
    curl -fsSL https://raw.githubusercontent.com/Apon77/linux/junk/functions.sh > ~/linux/functions.sh
    curl -fsSL https://raw.githubusercontent.com/Apon77/linux/junk/aliases.sh > ~/linux/aliases.sh

    echo "Creating deployment symbolic links to custom config directory..."
    ln -sf ~/linux/easy.zsh ~/.oh-my-zsh/custom/easy.zsh
    ln -sf ~/linux/functions.sh ~/.oh-my-zsh/custom/functions.zsh
    ln -sf ~/linux/aliases.sh ~/.oh-my-zsh/custom/aliases.zsh
fi

# --- Step 6: Initializing Session ---
print_header "Setup Finished!"
echo "Reloading your current terminal layout context settings..."
exec zsh

