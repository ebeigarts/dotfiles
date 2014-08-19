My dotfiles
-----------

These are config files to set up a system the way I like it.

## Installation

```
git clone git://github.com/ebeigarts/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
./osx
```

## Post-installation

[Setting user name, email and GitHub token](http://help.github.com/git-email-settings/)

```bash
git config --global user.name "your-name"
git config --global user.email "your-email"
git config --global github.user "your-github-username"
git config --global github.token "your-github-token"
```

[Setup MacVim](https://github.com/carlhuda/janus)

```bash
mkdir -p ~/.vim/janus/vim/colors/tomorrow/colors
curl https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/vim/colors/Tomorrow.vim \
  -o ~/.vim/janus/vim/colors/tomorrow/colors/Tomorrow.vim
```
