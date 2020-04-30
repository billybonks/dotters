if which brew > /dev/null; then
  echo 'Homebrew already installed. Skipping'
else
  echo 'Installing Homebrew'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# check if zsh is already installed
# nvm install cotains this could be usefull for finding out what terminal is being used
# "nvm source string already in /Users/billybonks/.zshrc"
if [[ -f ~/.zshrc ]]; then
    echo "zshrc already exists"
else
    brew install zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    curl https://raw.githubusercontent.com/billybonks/dotters/master/zshrc > ~/.zshrc
fi

if which rbenv > /dev/null; then
  echo 'rbenv already installed. Skipping'
else
  echo 'Installing rbenv and ruby-build'
  brew install rbenv
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor
fi

if [[ -n $(brew ls --versions ruby-build) ]]; then
  echo "ruby-build already installed. Skipping"
else
  echo "Installing ruby-build"
  brew install ruby-build
fi

if [[ -f ~/.vim ]]; then
    echo "vim folder aleady exits"
else
    curl https://raw.githubusercontent.com/billybonks/dotters/master/vim > ~/.vim
fi

if [[ -f ~/.vimrc ]]; then
    echo "vimrc already exists"
else
    curl https://raw.githubusercontent.com/billybonks/dotters/master/vimrc > ~/.vimrc
fi


if which psql > /dev/null; then
  echo 'rbenv already installed. Skipping'
else
  echo 'Installing postgres'
  brew install postgres
  brew services start postgresql
  #this is not sync so it fails
  psql -d postgres -c "CREATE DATABASE billybonks"
fi

if ! brew list | grep redis > /dev/null; then
  echo 'Installing Redis'
  brew install redis
  brew services start redis
else
  echo 'Redis already installed. Skipping'
fi

if  which heroku > /dev/null; then
  echo 'Installing heroku cli'
  brew tap heroku/brew && brew install heroku
else
  echo 'heroku cli already installed. Skipping'
fi

# To use the Heroku CLI's autocomplete --
#   Via homebrew's shell completion:
#     1) Follow homebrew's install instructions https://docs.brew.sh/Shell-Completion
#         NOTE: For zsh, as the instructions mention, be sure compinit is autoloaded
#               and called, either explicitly or via a framework like oh-my-zsh.
#     2) Then run
#       $ heroku autocomplete --refresh-cache
#
#   OR
#
#   Use our standalone setup:
#     1) Run and follow the install steps:
#       $ heroku autocomplete
#
# Bash completion has been installed to:
#   /usr/local/etc/bash_completion.d


if which nvm > /dev/null; then
  echo 'nvm already installed. Skipping'
else
  echo 'Installing nvm'
  mkdir ~/.nvm
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm install v10
  nvm install v12
fi

# Setup atom and vim
curl -fsSL https://raw.githubusercontent.com/billybonks/dotters/master/atom.sh | bash
curl -fsSL https://raw.githubusercontent.com/billybonks/dotters/master/vim.sh | bash


#Do this once all clones are completed, because it includes the private keys
if [[ -f ~/.gitconfig ]]; then
    echo "git config already exists"
else
    curl https://raw.githubusercontent.com/billybonks/dotters/master/gitconfig > ~/.gitconfig
fi
