#!/bin/bash

mkdir -p ~/linux
wget -O ~/linux/aliases.sh https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/aliases.sh
wget -O ~/linux/functions.sh https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/functions.sh
wget -O ~/linux/easy.bash https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/easy.bash

echo 'source ~/linux/aliases.sh
source ~/linux/functions.sh
source ~/linux/easy.bash' >> ~/.bashrc
