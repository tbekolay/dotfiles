# --- Basics
export ALTERNATE_EDITOR=""
export EDITOR="emacs-nw"
export VISUAL="emacs-nw"
export PAGER="less"

# --- Virtualenv
export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/Code"

# --- Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# --- WSL specific
if grep -q Microsoft /proc/version; then
    umask 022

# --- Debian specific
else
    export BROWSER="google-chrome"
    systemdpath=$(systemctl --user show-environment | grep '^PATH')
    if [[ $systemdpath != *"/home/tbekolay/"* ]]; then
        systemctl --user import-environment PATH
        systemctl restart --user emacs
    fi
    source "/usr/share/virtualenvwrapper/virtualenvwrapper.sh"
fi

# --- Convenience functions
exe() { echo "\$ $@" ; "$@" ; }

RSYNCOPTS=("-rtuv" "--exclude=*.pyc")
LOIHI="$HOME/Code/nengo-loihi/"
push_intel() {
    rsync "${RSYNCOPTS[@]}" --delete "$LOIHI" "intelhost:trevor/nengo-loihi"
}
pull_intel() {
    rsync "${RSYNCOPTS[@]}" "intelhost:trevor/nengo-loihi/" "$LOIHI"
}
push_abr() {
    rsync "${RSYNCOPTS[@]}" --delete "$LOIHI" "abrhost:nengo-loihi"
}
pull_abr() {
    rsync "${RSYNCOPTS[@]}" "abrhost:nengo-loihi/" "$LOIHI"
}

# --- zinit configuration

if [[ ! -d ~/.zinit ]]; then
    mkdir ~/.zinit
    git clone git@github.com:psprint/zinit.git ~/.zinit/bin
fi

source ~/.zinit/bin/zinit.zsh

zinit snippet PZT::modules/environment/init.zsh
zinit snippet PZT::modules/terminal/init.zsh

zinit ice nocompile
zinit snippet PZT::modules/editor/init.zsh

zinit snippet PZT::modules/history/init.zsh
zinit snippet PZT::modules/spectrum/init.zsh

zinit ice svn
zinit snippet PZT::modules/utility

zinit light zsh-users/zsh-completions
zinit light zdharma/fast-syntax-highlighting

zinit light zsh-users/zsh-history-substring-search
bindkey -M emacs "$key_info[Control]P" history-substring-search-up
bindkey -M emacs "$key_info[Control]N" history-substring-search-down
bindkey -M emacs "$key_info[Up]" history-substring-search-up
bindkey -M emacs "$key_info[Down]" history-substring-search-down

zinit ice svn
zinit snippet PZT::modules/git

zinit snippet PZT::modules/ssh/init.zsh
zinit snippet PZT::modules/gpg/init.zsh

zinit ice svn
zinit snippet PZT::modules/python

setopt promptsubst
zinit snippet "$HOME/Code/dotfiles/tbekolay-theme.zsh"

# --- Install completions
autoload -Uz compinit
compinit
zinit cdreplay -q

# --- Set or reset options
setopt EXTENDED_GLOB
unsetopt BEEP
unsetopt CLOBBER
unsetopt AUTO_CD
