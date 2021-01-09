git clone --recurse-submodules https://github.com/so-fancy/diff-so-fancy $HOME/.diff-so-fancy --depth=1
export PATH=$PATH:$HOME/.diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
