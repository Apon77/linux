#!/bin/bash

mkdir -p ~/linux
wget -O ~/linux/aliases.sh https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/aliases.sh
wget -O ~/linux/functions.sh https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/functions.sh
wget -O ~/linux/easy.bash https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/easy.bash

touch ~/.bashrc
grep -Fxq 'source ~/linux/aliases.sh' ~/.bashrc || echo 'source ~/linux/aliases.sh' >> ~/.bashrc
grep -Fxq 'source ~/linux/functions.sh' ~/.bashrc || echo 'source ~/linux/functions.sh' >> ~/.bashrc
grep -Fxq 'source ~/linux/easy.bash' ~/.bashrc || echo 'source ~/linux/easy.bash' >> ~/.bashrc
