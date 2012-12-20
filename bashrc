# ~/.bashrc: executed by bash(1) for non-login shells.
# cp -r /Users/edgarsbeigarts/.bash* ~/ && chown -R root:wheel ~/.bash*
# ln -s ~/.bash_profile ~/.profile

source ~/.bash/config

if [ -s ~/.rvm/scripts/rvm ] ; then
  source ~/.rvm/scripts/rvm
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
