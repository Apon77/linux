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
	curl -T $1 https://free.keep.sh
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
	curl -T $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB
}

upt() {
	curl -H "Max-Downloads: $2" -H "Max-Days: 5" -T $1 http://transfer.sh/$(basename $1); echo
	# 5 days, with max download limit of $2
	#usage: `upt file 1` for 1 time download
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
bot_api=1720254391:AAHCD2vGrm8-vzhrI9XwiUPQ1uCvHYoz6kM
your_telegram_id=$1
msg=$2
curl \
	-s "https://api.telegram.org/bot${bot_api}/sendmessage" \
	-d "text=$msg" \
	-d "chat_id=${your_telegram_id}" \
	-d "parse_mode=HTML"
#tg $id '<code>mono</code>'
#tg $id "<code>mono</code>"
#tg $id "<b>bold</b>"
#tg $id "<i>italic</i>"
#tg $id "<i><b>bold italic</b></i>"
#tg $id "<b><i>bold italic</i></b>"
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
cnf(){
	curl https://command-not-found.com/$1 -s|grep apt
}

PATH=$PATH:~/bin

#Usages
#echo -e "${Green}I am in green ${Blue}I am in blue"

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
