#! /bin/bash

# Bash script for install and construct development environment.
# Junseong Lee, a.k.a hodduc.
# 2013-07-29

# Check prerequisite
requisite=("curl" "git" "nvim")
for req in "${requisite[@]}"; do
  if ! command -v $req &> /dev/null; then
    echo "Install $req to continue."
    exit 1
  fi
done

# Generate working dir
WORK_DIR=$HOME/repos
CONF_DIR=$HOME/.config/nvim
mkdir -p $WORK_DIR
mkdir -p $CONF_DIR

# Clone dotfiles repo from github and extract it
git clone --recursive https://github.com/hodduc/dotfiles $WORK_DIR/dotfiles

# Install vimscript
echo -n 'Install neovim scripts...'

curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s $WORK_DIR/dotfiles/nvim/init.vim $CONF_DIR/init.vim
ln -s $WORK_DIR/dotfiles/nvim/coc_config.vim $CONF_DIR/coc_config.vim
ln -s $CONF_DIR/init.vim $HOME/.nvimrc

nvim +PlugInstall +qall

echo 'Done.'

# Install gitconfig & gitignore
rm -f $HOME/.gitconfig $HOME/.gitignore
ln -s $WORK_DIR/dotfiles/gitconfig $HOME/.gitconfig
ln -s $WORK_DIR/dotfiles/gitignore $HOME/.gitignore

# Install oh-my-zsh
echo -n 'Install oh-my-zsh ...'

rm -rf $HOME/.oh-my-zsh
rm -f $HOME/.zshrc

git clone https://github.com/robbyrussell/oh-my-zsh $HOME/.oh-my-zsh
ln -s $WORK_DIR/dotfiles/zshrc $HOME/.zshrc
chsh -s /bin/zsh

# Install misc
rm -f $HOME/.ripgreprc
ln -s $WORK_DIR/dotfiles/ripgreprc $HOME/.ripgreprc
echo 'Done. Restart your shell.'
