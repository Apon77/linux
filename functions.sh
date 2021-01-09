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

gcla() {
	git clone --recurse-submodules https://github.com/Apon77/$1
}

#upload limit 500MB and 24 Hours
up() {
	curl --upload-file $1 https://free.keep.sh
}

#upload limit 25GB, 3 Days and 1 time download
up2() {
	curl https://bashupload.com/$(basename $1) --data-binary @$1
}

up3() {
	curl -F file=@$1 https://api.anonymousfiles.io/
}

#speed test
st() {
	if [ -z "$1" ];then
		wget -O /dev/null --progress=dot:mega http://cachefly.cachefly.net/5mb.test ; date
	else	
		wget -O /dev/null --progress=dot:mega http://cachefly.cachefly.net/${1}mb.test ; date
	fi
}

#termux
if [[ $(uname -a) == *"Android"* ]]; then
[ ! -d ~/storage ] && termux-setup-storage
fi

#github/git config
git config --global credential.helper 'cache --timeout=36000' #10 hours cache
