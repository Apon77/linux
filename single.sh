#!/bin/bash

dl(){
local o="$1" u="$2"
command -v curl >/dev/null 2>&1 && curl -sL -o "$o" "$u" || wget -q -O "$o" "$u"
echo "$u > $o"
}
mkdir -p ~/linux/others ~/bin
touch ~/.bashrc

dl ~/linux/others/gai https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/others/gai
dl ~/linux/functions.sh https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/functions.sh
dl ~/linux/easy.bash https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/easy.bash
dl ~/linux/aliases.sh https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/aliases.sh
chmod +x ~/linux/others/gai
ln -sf ~/linux/others/gai ~/bin/gai

grep -Fxq 'source ~/linux/functions.sh' ~/.bashrc || echo 'source ~/linux/functions.sh' >> ~/.bashrc
grep -Fxq 'source ~/linux/easy.bash' ~/.bashrc || echo 'source ~/linux/easy.bash' >> ~/.bashrc
grep -Fxq 'source ~/linux/aliases.sh' ~/.bashrc || echo 'source ~/linux/aliases.sh' >> ~/.bashrc
