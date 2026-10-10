#!/bin/bash

mkdir -p ~/linux/others
wget -O ~/linux/functions.sh https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/functions.sh
wget -O ~/linux/easy.bash https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/easy.bash
wget -O ~/linux/aliases.sh https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/aliases.sh

touch ~/.bashrc
grep -Fxq 'source ~/linux/functions.sh' ~/.bashrc || echo 'source ~/linux/functions.sh' >> ~/.bashrc
grep -Fxq 'source ~/linux/easy.bash' ~/.bashrc || echo 'source ~/linux/easy.bash' >> ~/.bashrc
grep -Fxq 'source ~/linux/aliases.sh' ~/.bashrc || echo 'source ~/linux/aliases.sh' >> ~/.bashrc

wget -O ~/linux/others/gai https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/others/gai
chmod +x ~/linux/others/gai
ln -sf ~/linux/others/gai ~/bin/gai
