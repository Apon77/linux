ZSH_AUTOSUGGEST_STRATEGY=(history completion)

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

function gcla() {
	    git clone --recurse-submodules https://github.com/Apon77/$1
    }

#github/git config
git config --global credential.helper 'cache --timeout=36000' #10 hours cache

#termux
if [[ $(uname -a) == *"Android"* ]]; then
[ ! -d ~/storage ] && termux-setup-storage
fi

#alias
alias gcp='gpick'
alias gpc='gpick'
alias c='clear'
alias src='source ~/.zshrc'
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
alias easy="curl https://raw.githubusercontent.com/Apon77/linux/junk/easy.zsh > ~/.oh-my-zsh/custom/easy.zsh; source ~/.zshrc"
alias rs='repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j'
alias apon="curl https://raw.githubusercontent.com/Apon77/linux/junk/personal_variables.zsh > ~/.oh-my-zsh/custom/personal_variables.zsh; source ~/.zshrc"
