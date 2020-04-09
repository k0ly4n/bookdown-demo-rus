#!/bin/sh

ls /etc/apt/sources.list.d/nodesource.list || curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
grep npm-global ~/.profile || echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
. ~/.profile

npm install -g remark remark-lint remark-cli 
cd ~/ && npm install remark-preset-lint-markdown-style-guide remark-preset-lint-recommended remark-preset-lint-consistent remark-frontmatter remark-math remark-footnotes

