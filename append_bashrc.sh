echo 'source ~/linux/aliases.sh
source ~/linux/functions.sh
source ~/linux/personal_variables.sh
source ~/linux/easy.bash' >> ~/.bashrc

cat ~/linux/others/tmux.conf >> ~/.tmux.conf

git clone --recurse-submodules https://github.com/so-fancy/diff-so-fancy $HOME/.diff-so-fancy --depth=1

#curl https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/aliases.sh --create-dirs -o linux/aliases.sh; curl https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/functions.sh --create-dirs -o linux/functions.sh; curl https://raw.githubusercontent.com/Apon77/linux/refs/heads/junk/easy.bash --create-dirs -o linux/easy.bash #for temp env where git is not installed
