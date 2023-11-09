#install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
-- update zshrc


#install node
dnf dirmngr gpg curl gawk
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest

#install ruby
dnf install -y gcc rust patch make bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest
asdf global ruby latest


sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
#gpg key 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker
docker run --name postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

#Installing psql
sudo dnf install postgresql postgresql-devel
#connect to image using
#find ip using docker inspect postgres | grep IPAddress\"
#psql -h 172.17.0.2 -p 5432 -U postgres -W

# Redis installed directly on system
# https://developer.fedoraproject.org/tech/database/redis/about.html

#Install vim
sudo dnf install vim-enhanced;

#configure ssh agent
ssh-add ~/.ssh/github
eval "$(ssh-agent -s)"


##Update shortcuts in gnome terminal manually

