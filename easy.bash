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
alias gcl='git clone --recurse-submodules'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git pull'
alias gll='git pull origin main'
alias gm='git merge'
alias gma='git merge --abort'
alias gp='git push'
alias gr='git remote'
alias gra='git remote add'
alias grv='git remote -v'
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
alias md='mkdir -p'
alias rd='rmdir -p'
alias gke="\gitk --all $(git log -g --pretty=%h)"
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'
alias glo='git log --oneline --decorate'
alias glod='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'
alias glods='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'' --date=short'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all'
alias glols='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --stat'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'

echo 'set completion-ignore-case on' > ~/.inputrc

# extract file(s) from compressed status
extract() {
    local opt
    local OPTIND=1
    while getopts "hv" opt; do
        case "$opt" in
            h)
                cat <<End-Of-Usage
Usage: ${FUNCNAME[0]} [option] <archives>
    options:
        -h  show this message and exit
        -v  verbosely list files processed
End-Of-Usage
                return
                ;;
            v)
                local -r verbose='v'
                ;;
            ?)
                extract -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    [ $# -eq 0 ] && extract -h && return 1
    while [ $# -gt 0 ]; do
        if [[ ! -f "$1" ]]; then
            echo "extract: '$1' is not a valid file" >&2
            shift
            continue
        fi

        local -r filename=$(basename -- $1)
        local -r filedirname=$(dirname -- $1)
        local targetdirname=$(sed 's/\(\.tar\.bz2$\|\.tbz$\|\.tbz2$\|\.tar\.gz$\|\.tgz$\|\.tar$\|\.tar\.xz$\|\.txz$\|\.tar\.Z$\|\.7z$\)//g' <<< $filename)
        if [ "$filename" = "$targetdirname" ]; then
            # archive type either not supported or it doesn't need dir creation
            targetdirname=""
        else
            mkdir -v "$filedirname/$targetdirname"
        fi

        if [ -f "$1" ]; then
            case "$1" in
                *.tar.bz2|*.tbz|*.tbz2) tar "x${verbose}jf" "$1" -C "$filedirname/$targetdirname" ;;
                *.tar.gz|*.tgz) tar "x${verbose}zf" "$1" -C "$filedirname/$targetdirname" ;;
                *.tar.xz|*.txz) tar "x${verbose}Jf" "$1" -C "$filedirname/$targetdirname" ;;
                *.tar.Z) tar "x${verbose}Zf" "$1" -C "$filedirname/$targetdirname" ;;
                *.bz2) bunzip2 "$1" ;;
                *.deb) dpkg-deb -x${verbose} "$1" "${1:0:-4}" ;;
                *.pax.gz) gunzip "$1"; set -- "$@" "${1:0:-3}" ;;
                *.gz) gunzip "$1" ;;
                *.pax) pax -r -f "$1" ;;
                *.pkg) pkgutil --expand "$1" "${1:0:-4}" ;;
                *.rar) unrar x "$1" ;;
                *.rpm) rpm2cpio "$1" | cpio -idm${verbose} ;;
                *.tar) tar "x${verbose}f" "$1" -C "$filedirname/$targetdirname" ;;
                *.xz) xz --decompress "$1" ;;
                *.zip|*.war|*.jar) unzip "$1" ;;
                *.Z) uncompress "$1" ;;
                *.7z) 7za x "$1" ;;
                *) echo "'$1' cannot be extracted via extract" >&2;;
            esac
        fi

        shift
    done
}

alias x=extract

[ -d "$HOME/.diff-so-fancy" ] && export PATH=$PATH:$HOME/.diff-so-fancy && git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
