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
    ping google.com
fi
}

unalias gcl 2>/dev/null
gcl() {
	if [[ $1 == *"http"* ]]
	then
		git clone --recurse-submodules $1 $2
	else
		git clone --recurse-submodules https://github.com/$1 $2
	fi
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

iptv(){
input="$1"
output=$(basename $1 .m3u8)-filtered.m3u8
rm -rf $output

while IFS= read -r line;
do
        if [[ "$line" == *"EXT"* ]]; then echo $line >> $output; fi

        if [[ "$line" == *"http"* ]]; then
                if [[ "$line" == *".m3u8"* ]]; then
                        curl -s -m 1.5 $line|grep 'EXT' -q && echo $line &&  echo $line >> $output;
                fi;
        fi;
done < "$input"
}

function jqq() {
KEY=$1
num=$2
awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p
# curl *** | jqq id
}



ssh () {
        local max_attempts=3
        local attempt=1
        local extra_args=()
        extra_args+=("-o" "PubkeyAcceptedKeyTypes=+ssh-rsa")
        
        # ১. কমান্ড লাইন থেকে রিমোট হোস্টের IP বা নাম বের করা
        local target_host=""
        for arg in "$@"; do
            # SSH অপশন (-o, -p ইত্যাদি) বাদে হোস্ট নেম বা user@host খোঁজা
            if [[ "$arg" != -* && "$arg" != [0-9]* && "$arg" != *"="* ]]; then
                target_host="${arg#*@}" # user@host থেকে শুধু host আলাদা করা
            fi
        done

        while [ $attempt -le $max_attempts ]
        do
                local err_file=$(mktemp)
                env ssh "${extra_args[@]}" "$@" 2> "$err_file"
                local ssh_status=$?
                if [ $ssh_status -eq 0 ] || [ $ssh_status -eq 255 -a ! -s "$err_file" ]
                then
                        rm -f "$err_file"
                        return $ssh_status
                fi
                
                local error_handled=false
                local error_msg=$(cat "$err_file")
                rm -f "$err_file"
                
                # কাস্টম ফাংশন: .ssh/config-এ কনফিগারেশন রাইট করার জন্য
                write_to_ssh_config() {
                    local key="$1"
                    local value="$2"
                    if [ -n "$target_host" ]; then
                        echo -n "❓ Legacy $key detected for [$target_host]. Add to ~/.ssh/config permanently? (y/n): "
                        read -r response < /dev/tty
                        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
                            mkdir -p ~/.ssh && chmod 700 ~/.ssh
                            # আগে থেকে Host এন্ট্রি আছে কিনা চেক করা, না থাকলে নতুন তৈরি করা
                            if ! grep -q "Host $target_host" ~/.ssh/config 2>/dev/null; then
                                echo -e "\nHost $target_host" >> ~/.ssh/config
                            fi
                            # নির্দিষ্ট কনফিগারেশনটি যোগ করা (ডুপ্লিকেট এড়াতে awk বা sed ব্যবহার করা যেতে পারে, এখানে সরাসরি অ্যাপেন্ড করা হলো)
                            echo "    $key +$value" >> ~/.ssh/config
                            echo "✅ Saved to ~/.ssh/config! Now try running normal ssh again."
                        fi
                    fi
                }

                # ২. KEX Error Handling
                if echo "$error_msg" | grep -q "no matching key exchange method found"
                then
                        local raw_offers=$(echo "$error_msg" | grep -oE "Their offer: .*" | cut -d: -f2 | tr -d ' ')
                        local valid_kex=""
                        for algo in "diffie-hellman-group14-sha1" "diffie-hellman-group1-sha1" "diffie-hellman-group-exchange-sha1"
                        do
                                if echo "$raw_offers" | grep -q "$algo"; then
                                        valid_kex="${valid_kex:+$valid_kex,}$algo"
                                fi
                        done
                        if [ -n "$valid_kex" ]; then
                                write_to_ssh_config "KexAlgorithms" "$valid_kex"
                                # বর্তমান সেশনের জন্য কমান্ডে যোগ করা হচ্ছে যাতে কানেকশন ড্রপ না করে
                                extra_args+=("-oKexAlgorithms=+$valid_kex")
                                error_handled=true
                        fi
                fi

                # ৩. Host Key Error Handling
                if echo "$error_msg" | grep -q "no matching host key type found"
                then
                        local raw_offers=$(echo "$error_msg" | grep -oE "Their offer: .*" | cut -d: -f2 | tr -d ' ')
                        local valid_hk=""
                        for algo in "ssh-rsa" "ssh-dss"
                        do
                                if echo "$raw_offers" | grep -q "$algo"; then
                                        valid_hk="${valid_hk:+$valid_hk,}$algo"
                                fi
                        done
                        if [ -n "$valid_hk" ]; then
                                write_to_ssh_config "HostKeyAlgorithms" "$valid_hk"
                                extra_args+=("-oHostKeyAlgorithms=+$valid_hk")
                                error_handled=true
                        fi
                fi

                # ৪. Host Identification Changed Error Handling
                if echo "$error_msg" | grep -q "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED"
                then
                        echo "⚠️  Remote host key changed for $target_host! Removing old key..."
                        ssh-keygen -R "$target_host" 2> /dev/null
                        error_handled=true
                fi

                if [ "$error_handled" = false ]
                then
                        echo "$error_msg" >&2
                        return $ssh_status
                fi

                echo "🔄 Retrying connection with updated parameters..."
                attempt=$((attempt + 1))
        done
        return 1
}




ssh-copy-id() {
    local max_attempts=3
    local attempt=1
    local extra_args=()

    # ssh-copy-id এর জন্যও পাবলিক কি অপশনটি ডিফল্টভাবে যুক্ত করা হলো
    extra_args+=("-o" "PubkeyAcceptedKeyTypes=+ssh-rsa")

    while [ $attempt -le $max_attempts ]; do
        local err_file=$(mktemp)
        
        env ssh-copy-id "${extra_args[@]}" "$@" 2> "$err_file"
        local ssh_status=$?

        if [ $ssh_status -eq 0 ] || [ $ssh_status -eq 255 -a ! -s "$err_file" ]; then
            rm -f "$err_file"
            return $ssh_status
        fi

        local error_handled=false
        local error_msg=$(cat "$err_file")
        rm -f "$err_file"

        if echo "$error_msg" | grep -q "no matching key exchange method found"; then
            local raw_offers=$(echo "$error_msg" | grep -oE "Their offer: .*" | cut -d: -f2 | tr -d ' ')
            local valid_kex=""
            for algo in "diffie-hellman-group14-sha1" "diffie-hellman-group1-sha1" "diffie-hellman-group-exchange-sha1"; do
                if echo "$raw_offers" | grep -q "$algo"; then
                    valid_kex="${valid_kex:+$valid_kex,}$algo"
                fi
            done
            if [ -n "$valid_kex" ]; then
                echo "⚠️  [ssh-copy-id] Legacy KEX detected! Adding options..."
                extra_args+=("-o" "KexAlgorithms=+$valid_kex")
                error_handled=true
            fi
        fi

        if echo "$error_msg" | grep -q "no matching host key type found"; then
            local raw_offers=$(echo "$error_msg" | grep -oE "Their offer: .*" | cut -d: -f2 | tr -d ' ')
            local valid_hk=""
            for algo in "ssh-rsa" "ssh-dss"; do
                if echo "$raw_offers" | grep -q "$algo"; then
                    valid_hk="${valid_hk:+$valid_hk,}$algo"
                fi
            done
            if [ -n "$valid_hk" ]; then
                echo "⚠️  [ssh-copy-id] Legacy HostKey detected! Adding options..."
                extra_args+=("-o" "HostKeyAlgorithms=+$valid_hk")
                error_handled=true
            fi
        fi

        if echo "$error_msg" | grep -q "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED"; then
            local target_host=""
            for arg in "$@"; do target_host="$arg"; done
            echo "⚠️  [ssh-copy-id] Remote host key changed for $target_host! Removing old key..."
            ssh-keygen -R "$target_host" 2>/dev/null
            error_handled=true
        fi

        if [ "$error_handled" = false ]; then
            echo "$error_msg" >&2
            return $ssh_status
        fi

        echo "🔄 Retrying ssh-copy-id with updated parameters..."
        attempt=$((attempt + 1))
    done

    return 1
}



PATH=$PATH$( find ~/bin -type d -printf ":%p" )

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
