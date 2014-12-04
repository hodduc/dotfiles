#################################################################################################
# See http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/ #
#################################################################################################

# Install brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Add coreutils to PATH: This line should be appended to zshrc/bashrc
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

brew tap homebrew/dupes

# Install newer
brew install binutils
brew install diffutils
brew install ed --default-names
brew install findutils --default-names
brew install gawk
brew install gnu-indent --default-names
brew install gnu-sed --default-names
brew install gnu-tar --default-names
brew install gnu-which --default-names
brew install gnutls --default-names
brew install grep --default-names
brew install gzip
brew install screen
brew install watch
brew install wdiff --with-gettext
brew install wget


# Install newer version than default shipped one in OS X
brew install bash
brew install emacs
brew install gdb  # gdb requires further actions to make it work. See `brew info gdb`.
brew install gpatch
brew install m4
brew install make
brew install nano


# And non GNU CLI....
brew install file-formula
brew install git
brew install less
brew install openssh --with-brewed-openssl
brew install perl518   # must run "brew tap homebrew/versions" first!
brew install python --with-brewed-openssl
brew install rsync
brew install svn
brew install unzip
brew install vim --override-system-vi
brew install macvim --override-system-vim --custom-system-icons
brew install zsh


# Update: You may also want to add $HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman to the MANPATH environmental variable,
# where $HOMEBREW_PREFIX is the prefix of Homebrew, which is /usr/local by default. (Thanks Matthew Walker!)
# Alternatively, there is also a one-line setup which you could put in your shell configuration files here by quickshiftin.
