ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# aliases
alias src='source ~/.zshrc'
alias nz='nano ~/.zshrc'
alias vz='vim ~/.zshrc'
alias a="curl https://raw.githubusercontent.com/Apon77/linux/junk/aliases.sh > ~/.oh-my-zsh/custom/aliases.zsh; source ~/.zshrc"
alias easy="curl https://raw.githubusercontent.com/Apon77/linux/junk/easy.zsh > ~/.oh-my-zsh/custom/easy.zsh; source ~/.zshrc"
alias fn="curl https://raw.githubusercontent.com/Apon77/linux/junk/functions.sh > ~/.oh-my-zsh/custom/functions.zsh; source ~/.zshrc"
alias apon="curl https://raw.githubusercontent.com/Apon77/linux/junk/personal_variables.sh > ~/.oh-my-zsh/custom/personal_variables.zsh; source ~/.zshrc"
alias gll=ggpull

export PATH=$PATH:$HOME/.diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
