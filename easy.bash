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

function gcla() {
    git clone https://github.com/Apon77/$1
}

#git cherry-pick
#Usage, gpick https://github.com/Apon77/linux/commit/98f40ee2035c73093bba1dca0080fa178ed0dc36
#Or, gcp https://github.com/Apon77/linux/commit/98f40ee2035c73093bba1dca0080fa178ed0dc36
gpick() {
if [[ $1 == *"http"* ]]
then
    repo_url=$(echo $1 | cut -f -5 -d "/")
    commit_hash=$(echo $1 | cut -f 7 -d "/")
    if [[ $1 == *"diff"* ]]
    then
	    commit_hash=$(echo $1 | cut -f 7 -d '/' | cut -f 1 -d '#')
    fi
    git remote add temp_remote $repo_url
    git fetch temp_remote
    git cherry-pick $commit_hash
    git remote rm temp_remote
else
    git cherry-pick $1
fi
}

#deldog
deldog() {
    RESULT=$(curl -sf --data-binary @"${1:--}" https://del.dog/documents) || {
        echo "ERROR: failed to post document" >&2
        return 1
    }
    KEY=$(printf  "%s\n" "${RESULT}" | cut -d '"' -f6)
    echo "https://del.dog/${KEY}"
}

# ping
p() {
if [[ $1 == *"."* ]]
then
    ping $1
else
    ping 8.8.8.8
fi
}

#github/git config
git config --global credential.helper 'cache --timeout=36000' #10 hours cache

#termux
if [[ $(uname -a) == *"Android"* ]]; then
[ ! -d ~/storage ] && termux-setup-storage
fi

#alias
alias c=clear
alias gcp='gpick'
alias gpc='gpick'
alias n='nano'
alias v='vim'
alias tx='tmux'
alias t='tmux attach -t0'
alias t1='tmux attach -t1'
alias ta='tmux attach -t'
alias tl='tmux ls'
alias h='htop'
alias cc='ccache -s'
alias s='source'
alias q='exit'
alias e='echo'
alias du='du -h'
alias dus='du -sh'
alias df='df -h'
alias rmrf='rm -rf'
alias path='echo -e ${PATH//:/\\n}'
alias myip="curl http://ipecho.net/plain; echo"
alias st='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias rs='repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j'

#github/git config
git config --global user.name "Apon77"
git config --global user.email "khalakuzzamanapon5@gmail.com"
git config --global core.editor vim

export TZ='Asia/Dhaka'
alias gdup='gdrive upload -p 1DuHbMh4ogKDGbjSNP-7xLPY3S1KW1Z1i'
