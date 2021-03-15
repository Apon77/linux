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
    git remote| grep temp_remote && git remote remove temp_remote
    git fetch $repo_url && git log FETCH_HEAD --pretty=oneline | cut -d ' ' -f 1 | grep $commit_hash && git cherry-pick $commit_hash || (git remote add temp_remote $repo_url && git fetch temp_remote && git cherry-pick $commit_hash && git remote rm temp_remote)
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
if [[  -n "$1"  ]]
then
    ping $1
else
    ping 8.8.8.8
fi
}

gcla() {
	git clone --recurse-submodules https://github.com/Apon77/$1
}

up() {
	curl --upload-file $1 https://free.keep.sh
	#upload limit 500MB and 24 Hours
}

up2() {
	curl https://bashupload.com/$(basename $1) --data-binary @$1
	#upload limit 25GB, 3 Days and 1 time download
}

up3() {
	curl -F file=@$1 https://api.anonymousfiles.io/
}

up4() {
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB
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

# Usages tg id msg
tg(){
bot_api=1692865707:AAHvKZogI5sUGtqjd2sZvNl8tib0Q_xcYkY
your_telegram_id=$1
msg=$2
curl -s "https://api.telegram.org/bot${bot_api}/sendmessage" --data "text=$msg&chat_id=${your_telegram_id}"
}

#github/git config
git config --global credential.helper 'cache --timeout=36000' #10 hours cache
# git config --global credential.helper store (Don't use if any other has access to your pc)

gpp(){
	git add --all
	git commit -m $1
	git push
}

mcd(){
	mkdir -p $1
	cd $1
}

HISTTIMEFORMAT="%d/%m/%y %T "

com(){
	tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}

m(){
	curl cheat.sh/$1
}
