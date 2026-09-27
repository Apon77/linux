#!/bin/bash

# --- Step 1: Oh My Zsh ---
echo "== Step 1: Oh My Zsh =="
read -p "Install Oh My Zsh? (Y/n): " ans
if [[ -z $ans || $ans == y* ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --- Step 2: Plugins ---
echo "== Step 2: Plugins =="

read -p "Install zsh-autosuggestions? (Y/n): " ans
if [[ -z $ans || $ans == y* ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

read -p "Install zsh-history-substring-search? (Y/n): " ans
if [[ -z $ans || $ans == y* ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
fi

read -p "Install zsh-syntax-highlighting? (Y/n): " ans
if [[ -z $ans || $ans == y* ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

read -p "Install diff-so-fancy? (Y/n): " ans
if [[ -z $ans || $ans == y* ]]; then
    git clone --recurse-submodules --depth=1 https://github.com/so-fancy/diff-so-fancy $HOME/.diff-so-fancy
fi

# --- Step 3: Powerlevel10k theme ---
echo "== Step 3: Powerlevel10k theme =="
read -p "Install Powerlevel10k? (Y/n): " ans
if [[ -z $ans || $ans == y* ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
    curl -fsSL https://raw.githubusercontent.com/Apon77/linux/junk/.p10k.zsh > ~/.p10k.zsh
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
fi

# --- Step 4: Update plugins line in ~/.zshrc ---
echo "== Step 4: .zshrc plugins list =="
read -p "Update the plugins line in ~/.zshrc? (Y/n): " ans
if [[ -z $ans || $ans == y* ]]; then
    sed -i 's/plugins=(git)/plugins=(git z command-not-found extract zsh-autosuggestions history-substring-search zsh-syntax-highlighting)/g' ~/.zshrc
fi

# --- Step 5: Custom configs (easy, functions, aliases) ---
echo "== Step 5: Custom configs =="
read -p "Download and link easy/functions/aliases scripts? (Y/n): " ans
if [[ -z $ans || $ans == y* ]]; then
    mkdir -p ~/linux

    curl -fsSL https://raw.githubusercontent.com/Apon77/linux/junk/easy.zsh > ~/linux/easy.zsh
    curl -fsSL https://raw.githubusercontent.com/Apon77/linux/junk/functions.sh > ~/linux/functions.sh
    curl -fsSL https://raw.githubusercontent.com/Apon77/linux/junk/aliases.sh > ~/linux/aliases.sh

    ln -sf ~/linux/easy.zsh ~/.oh-my-zsh/custom/easy.zsh
    ln -sf ~/linux/functions.sh ~/.oh-my-zsh/custom/functions.zsh
    ln -sf ~/linux/aliases.sh ~/.oh-my-zsh/custom/aliases.zsh
fi

# --- Done ---
echo "== Setup finished =="
exec zsh
