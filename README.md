dotfiles
========

Hodduc's dotfiles

  Prerequisite: NeoVim, git
  
  Type:
    `curl -L https://raw.githubusercontent.com/hodduc/dotfiles/master/install.sh | bash`

  Recommendation:
```sh
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0

    asdf plugin add rust
    asdf install rust 1.15.0
    asdf global rust 1.15.0

    cargo install bat
    cargo install exa
    cargo install ripgrep

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
```
