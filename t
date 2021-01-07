# google cloud shell
if [[ $(whoami) == *"apon"* ]]; then
cd ~/.oh-my-zsh/plugins/z
git fetch https://github.com/Apon77/z
git cherry-pick 11d5d7eaaa47541659ebf2e8e93ce15e6df946fb
cd -
fi


