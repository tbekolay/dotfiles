# --- Basics
export ALTERNATE_EDITOR=""
export EDITOR="emacs-nw"
export VISUAL="emacs-nw"
export PAGER="less"

path=(
    $HOME/bin
    $HOME/.npm/bin
    $HOME/.cargo/bin
    $HOME/.cask/bin
    $(gem env gempath | cut -d : -f 1)/bin
    /usr/local/{bin,sbin}
    /usr/local/opt/ruby/bin
    /usr/local/share/npm/bin
    /usr/texbin
    $path
)

# --- Virtualenv
export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/Code"

# --- Ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# --- Mac OS X specific
if [[ $(uname) == 'Darwin' ]]; then
    path=(
        '/usr/local/opt/python/libexec/bin'
        $path
    )

# --- WSL specific
elif grep -q Microsoft /proc/version; then
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
NXSDK="$HOME/Code/NxSDK/"
push_intel() {
    rsync "${RSYNCOPTS[@]}" --delete "$LOIHI" "intelhost:trevor/nengo-loihi"
    rsync -rtuv --delete "$NXSDK" "intelhost:trevor/NxSDK"
}
pull_intel() {
    rsync "${RSYNCOPTS[@]}" "intelhost:trevor/nengo-loihi/" "$LOIHI"
}
push_abr() {
    rsync "${RSYNCOPTS[@]}" --delete "$LOIHI" "abrhost:nengo-loihi"
    rsync -rtuv --delete "$NXSDK" "abrhost:NxSDK"
}
pull_abr() {
    rsync "${RSYNCOPTS[@]}" "abrhost:nengo-loihi/" "$LOIHI"
}

# --- zplugin configuration

if [[ ! -d ~/.zplugin ]]; then
    mkdir ~/.zplugin
    git clone git@github.com:zdharma/zplugin.git ~/.zplugin/bin
fi

source ~/.zplugin/bin/zplugin.zsh

zplugin snippet PZT::modules/environment/init.zsh
zplugin snippet PZT::modules/terminal/init.zsh

zplugin ice nocompile
zplugin snippet PZT::modules/editor/init.zsh

zplugin snippet PZT::modules/history/init.zsh
zplugin snippet PZT::modules/spectrum/init.zsh

zplugin ice svn
zplugin snippet PZT::modules/utility

zplugin light zsh-users/zsh-completions
zplugin light zdharma/fast-syntax-highlighting

zplugin light zsh-users/zsh-history-substring-search
bindkey -M emacs "$key_info[Control]P" history-substring-search-up
bindkey -M emacs "$key_info[Control]N" history-substring-search-down
bindkey -M emacs "$key_info[Up]" history-substring-search-up
bindkey -M emacs "$key_info[Down]" history-substring-search-down

zplugin ice svn
zplugin snippet PZT::modules/git

zplugin snippet PZT::modules/gpg/init.zsh

zplugin ice svn
zplugin snippet PZT::modules/python

setopt promptsubst
zplugin snippet "$HOME/Code/dotfiles/tbekolay-theme.zsh"

# --- Install completions
autoload -Uz compinit
compinit
zplugin cdreplay -q

# --- Set or reset options
setopt EXTENDED_GLOB
unsetopt BEEP
unsetopt CLOBBER
unsetopt AUTO_CD
