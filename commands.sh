#!/bin/bash
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search

#zsh-syntax-highlighting must be the last plugin sourced.
sed -i 's/plugins=(git)/plugins=(git z zsh-autosuggestions history-substring-search zsh-syntax-highlighting)/g' ~/.zshrc
sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' ~/.zshrc
curl https://raw.githubusercontent.com/Apon77/linux/junk/easy > ~/.oh-my-zsh/custom/easy.zsh
#nano ~/.zshrc
#ZSH_THEME="powerlevel10k/powerlevel10k"
#p10k configure
#source ~/.zshrc