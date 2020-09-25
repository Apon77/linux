#!/bin/bash
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/g' ~/.zshrc
curl https://raw.githubusercontent.com/Apon77/linux/junk/easy >> ~/.zshrc
#nano ~/.zshrc
#ZSH_THEME="powerlevel10k/powerlevel10k"
#p10k configure
source ~/.zshrc
