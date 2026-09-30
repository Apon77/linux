echo 'source ~/linux/aliases.sh
source ~/linux/functions.sh
source ~/linux/personal_variables.sh
source ~/linux/easy.bash' >> ~/.bashrc

cat ~/linux/others/tmux.conf >> ~/.tmux.conf

git clone --recurse-submodules https://github.com/so-fancy/diff-so-fancy $HOME/.diff-so-fancy --depth=1
