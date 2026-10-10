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

#termux
if [[ $(uname -a) == *"Android"* ]]; then
[ ! -d ~/storage ] && termux-setup-storage
fi

HISTTIMEFORMAT="%d/%m/%y %T "

[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

bak () {
	cp $1 $1.bak -a
}

cnf(){
	curl https://command-not-found.com/$1 -s|grep apt
}

com(){
	if [[ -z "$1" ]]; then
		echo "Usage: com <directory_name> [compression_level_1-9; 9=high]"
		echo "Example: com myfolder"
		echo "Example: com myfolder 9"
		return 1
	fi
	tar --use-compress-program="pigz -k -${2:-6}" -cf "$1.tar.gz" "$1"
}

de () {
    local F="$HOME/electricity_log.txt" TMP="$F.tmp" live_data
    live_data=$(curl "$desco_url/getCustomerDailyConsumption?accountNo=$desco_accountno&dateFrom=$(date -d '40 days ago' +%Y-%m-%d)&dateTo=$(date +%Y-%m-%d)" -ks | jq -r '.data | sort_by(.date) | ["Date", "Diff Taka (৳)", "Diff Unit (kWh)", "Taka/Unit"], (range(1; length) as $i | (if .[$i].date | endswith("-01") then (.[$i].consumedTaka * 100 | round / 100) else ((.[$i].consumedTaka - .[$i-1].consumedTaka) * 100 | round / 100) end) as $taka | ((.[$i].consumedUnit - .[$i-1].consumedUnit) * 1000 | round / 1000) as $unit | [.[$i].date, $taka, $unit, (if $unit == 0 then 0 else (($taka / $unit) * 100 | round / 100) end)]) | @tsv')
    [ -f "$F" ] || echo "$live_data" | head -n 1 > "$F"
    { head -n 1 "$F"; { tail -n +2 "$F" 2>/dev/null; echo "$live_data" | tail -n +2; } | sort -k1,1 -u; } > "$TMP" && mv "$TMP" "$F"
    column -t -s $'\t' < "$F"
}

deb () {
    local F="$HOME/balance_log.txt"
    local raw_data
    raw_data=$(curl "$desco_url/getBalance?accountNo=$desco_accountno" -ks | jq -r '.data | "\(.readingTime)\t\(.balance)"')
    [ -z "$raw_data" ] || [ "$raw_data" = "null null" ] && { echo "Error: No data" >&2; return 1; }
    [ -f "$F" ] || echo -e "Reading Time\tBalance" > "$F"
    grep -Fxq "$raw_data" "$F" || echo "$raw_data" >> "$F"
    column -t -s $'\t' < "$F"
}

decom() {
	if [[ -z "$1" ]]; then
		echo "Usage: decom <filename.tar.gz> [destination_path]"
		echo "Example: decom archive.tar.gz"
		echo "Example: decom archive.tar.gz /path/to/dir"
		return 1
	fi
	local dest="${2:-$HOME/bin}"
	mkdir -p "$dest"
	tar xzvf "$1" -C "$dest"
}

deldog() {
    RESULT=$(curl -sf --data-binary @"${1:--}" https://del.dog/documents) || {
        echo "ERROR: failed to post document" >&2
        return 1
    }
    KEY=$(printf  "%s\n" "${RESULT}" | cut -d '"' -f6)
    echo "https://del.dog/${KEY}"
}

der(){
        curl "$desco_url/getRechargeHistory?accountNo=$desco_accountno&dateFrom=$(date -d '360 days ago' +%Y-%m-%d)&dateTo=$(date +%Y-%m-%d)" -ks | jq -r '["Date & Time", "Total Amount", "Energy Amount"], (.data |= sort_by(.rechargeDate) | .data[] | [.rechargeDate, .totalAmount, .energyAmount]) | @tsv' | column -t -s $'\t'
}

dka(){
	docker start "$1" && docker attach "$1"
}

gac() {
  git add --all
  git commit -m "$*"
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

#git cherry-pick
gpick() {
if [[ -z "$1" ]]; then
    echo "Usage: gpick <commit_url_or_hash>  OR  gcp <commit_url_or_hash>"
    echo "Example: gpick https://github.com/Apon77/linux/commit/98f40ee2035c73093bba1dca0080fa178ed0dc36"
    return 1
fi

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

gpp(){
	git add --all
	git commit -m $1
	git push
}

ipa() {
    printf "%-4s %-18s %-18s %-18s
" "IDX" "INTERFACE" "IP ADDRESS" "MAC ADDRESS"
    printf "%-4s %-18s %-18s %-18s
" "---" "---------" "----------" "-----------"

    ip -o link | while read -r line; do
        id=$(echo "$line" | cut -d: -f1)
        name=$(echo "$line" | cut -d: -f2 | tr -d ' ')
        ip=$(ip -o -4 addr show dev "$name" 2>/dev/null | awk '{print $4}')
        mac=$(ip link show dev "$name" 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}' | head -n 1)

        [ -z "$ip" ] && ip="N/A"
        [ -z "$mac" ] && mac="N/A"

        printf "%-4s %-18s %-18s %-18s
" "$id" "$name" "$ip" "$mac"
    done
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

lp() {
        local r="$HOME/bin"
        [ ! -d "$r" ] && echo "❌ Error: $r missing." && return 1

        # 1. Remove broken symlinks in ~/bin
        while IFS= read -r broken; do
                rm -f "$broken" && echo "🗑️  Removed: $(basename "$broken")"
        done < <(find "$r" -maxdepth 1 -type l -xtype l)

        # 2. Scan subdirectories in ~/bin
        while IFS= read -r d; do
                local s="$d"
                # If the dir has a 'bin' subfolder, use that instead
                [ -d "$d/bin" ] && s="$d/bin"

                # Find executables inside the directory
                while IFS= read -r e; do
                        local n
                        n=$(basename "$e")
                        
                        # Skip if it's named 'bin'
                        [ "$n" = "bin" ] && continue

                        # Create symlink in ~/bin
                        if ln -sf "$e" "$r/$n"; then
                                echo "🔗 Added: $n -> $e"
                        else
                                echo "❌ Failed to link: $n"
                        fi
                done < <(find "$s" -maxdepth 5 -type f -executable)

        done < <(find "$r" -mindepth 1 -maxdepth 1 -type d)

        echo "✅ Done!"
}





m(){
	curl cheat.sh/$1
}

mcd(){
	mkdir -p $1
	cd $1
}

p() {
if [[  -n "$1"  ]]
then
    ping $1
else
    ping google.com
fi
}

sleep() {
    for i in $(seq "$1" -1 1); do echo -ne "$i \r"; command sleep 1; done; echo -ne "\r   \r"
}

st() {
	if [ -z "$1" ];then
		command -v wget >/dev/null 2>&1 && wget -O /dev/null --progress=dot:mega http://cachefly.cachefly.net/5mb.test && date || curl -o /dev/null http://cachefly.cachefly.net/5mb.test 
		
	else	
		wget -O /dev/null --progress=dot:mega http://cachefly.cachefly.net/${1}mb.test && date || curl -o /dev/null http://cachefly.cachefly.net/${1}mb.test 

	fi
}

# Usages tg id msg
tg(){
	if [[ -z "$1" || -z "$2" ]]; then
		echo "Usage: tg <telegram_id> <message>"
		echo "tg \$id '<code>mono</code>'"
		echo "tg \$id \"<code>mono</code>\""
		echo "tg \$id \"<b>bold</b>\""
		echo "tg \$id \"<i>italic</i>\""
		echo "tg \$id \"<i><b>bold italic</b></i>\""
		echo "tg \$id \"<b><i>bold italic</i></b>\""
		return 1
	fi
	bot_api=1720254391:AAHCD2vGrm8-vzhrI9XwiUPQ1uCvHYoz6kM
	your_telegram_id=$1
	msg=$2
	curl \
		-s "https://api.telegram.org/bot${bot_api}/sendmessage" \
		-d "text=$msg" \
		-d "chat_id=${your_telegram_id}" \
		-d "parse_mode=HTML"
}

u() {
    docker compose -f ~/linux/others/docker-ubuntu-24.04.yml run --rm --name ubuntu "$@" ubuntu
}

up() {
	curl -T $1 https://free.keep.sh
	#upload limit 500MB and 24 Hours
}

up() {
	curl --upload-file $1 https://sendit.sh/
}

up2() {
	curl https://bashupload.com/$(basename $1) --data-binary @$1
	#upload limit 25GB, 3 Days and 1 time download
}

up2() {
	curl -H "X-Expiration-Seconds: 86400" bashupload.app -T $1
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

#github/git config
#command -v git &>/dev/null && git config --global credential.helper 'cache --timeout=1800' #10 hours cache
# git config --global credential.helper store (Don't use if any other has access to your pc)

# Git credential setup (1=Personal, 2=Shared [default: 30m cache])
gcr() {
	echo "\033[1;34m[Git Credential Setup]\033[0m"
	echo "1) Personal"
	echo "2) Shared (default)"
	printf "Select [2]: "
	read -r a
	if [[ "$a" == "1" ]]; then
		git config --global credential.helper store
		echo "\033[1;32m[+] Mode: Permanent\033[0m"
	else
		git config --global credential.helper 'cache --timeout=1800'
		echo "\033[1;33m[+] Mode: 30m Cache\033[0m"
	fi
}
