rm .zshrc
rm .vimrc
cp ~/.vimrc .vimrc
cp ~/.zshrc .zshrc
git add .
git commit -m 'update dotfiles'
git push origin master

