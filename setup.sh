/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
reset
#go to preset and configure keys to natural text editing
brew install postgres
brew services
brew services start postgresql
psql -d postgres -c "CREATE DATABASE billybonks"
brew install redis
brew services start redis
#redis-server /usr/local/etc/redis.conf
brew install rbenv
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
#open a new terminal
rbenv init
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
nvm install v8
nvm install v10
nvm install v9
curl https://raw.githubusercontent.com/billybonks/dotters/master/gitconfig > ~/.gitconfig
curl https://raw.githubusercontent.com/billybonks/dotters/master/zshrc > ~/.zshrc
brew install heroku/brew/heroku
