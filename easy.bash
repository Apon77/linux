PS1='\[\e[0;38;5;41m\]\w\[\e[0;93m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2)\[\e[0;38;5;201m\]\$\[\e[m\] \[\e[0m\]\[\e0'
alias src='source ~/.bashrc'
alias nb='nano ~/.bashrc'
alias vb='vim ~/.bashrc'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias gst='git status'
alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gbD='git branch -D'
alias gbd='git branch -d'
alias gba='git branch -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias gc='git commit -v'
alias 'gc!'='git commit -v --amend'
alias gcf='git config --list'
alias gcl='glit clone --recurse-submodules'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git pull'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias gm='git merge'
alias gma='git merge --abort'
alias gp='git push'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grm='git rm'
alias grrm='git remote remove'
alias gsh='git show'
alias l='ls -lah'
alias ll='ls -lh'
alias ls='ls --color=tty'
