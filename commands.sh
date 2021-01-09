#!/bin/bash
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
git clone --recurse-submodules https://github.com/so-fancy/diff-so-fancy $HOME/.diff-so-fancy --depth=1

#Adding p10k theme
#git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
#curl https://raw.githubusercontent.com/Apon77/linux/junk/.p10k.zsh > ~/.p10k.zsh

#zsh-syntax-highlighting must be the last plugin sourced.
sed -i 's/plugins=(git)/plugins=(git z command-not-found extract zsh-autosuggestions history-substring-search zsh-syntax-highlighting)/g' ~/.zshrc
#sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' ~/.zshrc

curl https://raw.githubusercontent.com/Apon77/linux/junk/easy.zsh > ~/.oh-my-zsh/custom/easy.zsh
curl https://raw.githubusercontent.com/Apon77/linux/junk/functions.sh > ~/.oh-my-zsh/custom/functions.zsh
curl https://raw.githubusercontent.com/Apon77/linux/junk/aliases.sh > ~/.oh-my-zsh/custom/aliases.zsh
#nano ~/.zshrc
#ZSH_THEME="powerlevel10k/powerlevel10k"
#p10k configure
source ~/.zshrc
