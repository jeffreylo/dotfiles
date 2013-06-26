# Lines configured by zsh-newuser-install
HISTFILE=~/.histories/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep notify
bindkey -e
# End of lines configured by zsh-newuser-install

for file in ~/.config/zsh/.zsh_*
do
    [ -r "$file" ] && source "$file"
done


autoload -U compinit
compinit -d ~/.config/zsh/.zcompdump

setopt correct

export FPATH=~/.config/zsh/functions:$FPATH
autoload -Uz catl fl md mva sw
