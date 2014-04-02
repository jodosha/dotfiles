#!/bin/bash

dtrace_version="20130623"
redis_version="2.8.3"
ruby_version="2.1.0-p0"

sudo apt-get update
sudo apt-get install -y build-essentials autoconf libssl-dev libyaml-dev libreadline6 \
  libreadline6-dev zlib1g zlib1g-dev curl openssl libssl-dev golang git-core \
  postgresql nodejs valgrind sqlite3 libsqlite3-dev

# DTrace
curl ftp://crisp.dyndns-server.com/pub/release/website/dtrace/dtrace-$dtrace_version.tar.bz2 | jx
cd dtrace-$dtrace_version
./tools/get-deps.pl
make all
sudo make install
sudo make load
cd .. && rm -rf dtrace-$dtrace_version

# Ruby
exec $SHELL -l
cd ~
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL -l

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL -l

echo "gem: --no-ri --no-rdoc" > ~/.gemrc

rbenv install $ruby_version --with-openssl-dir=/usr/local --enable-dtrace
rbenv global $ruby_version
rbenv rehash

gem update --system
gem install bundler
gem install debugger-ruby_core_source
gem install debugger-linecache
gem install debugger
rbenv rehash

curl http://download.redis.io/releases/redis-$redis_version.tar.gz | tar zx
cd redis-$redis_version && make && sudo make install
