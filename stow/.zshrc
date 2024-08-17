# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# Custom system commands
alias clip='xclip -selection clipboard'

# Path
export PATH="$HOME/scripts:$PATH"

# Custom Dev Commands
alias clt='docker container start cern-wp-theme-lite-wordpress-1 && docker container start cern-wp-theme-lite-database-1 && cd ~/projects/cern-wp-theme-lite/wp-content/themes/cern-lite/src && nvim'
alias cltn='docker container start cern-wp-theme-lite-node && cd ~/projects/cern-wp-theme-lite/wp-content/themes/cern-lite && docker-compose exec node /bin/bash'
