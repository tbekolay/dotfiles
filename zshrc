# --- Basics
export ALTERNATE_EDITOR=""
export EDITOR="emacs-nw"
export VISUAL="emacs-nw"
export PAGER="less"
unsetopt AUTO_CD

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

# --- Debian in Windows specific
if $WSL; then
    ;

# --- Mac OS X specific
elif [[ $(uname) == 'Darwin' ]]; then
    ;

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

# --- zplug configuration

if [[ ! -d ~/.zplug ]]; then
    git clone git@github.com:zplug/zplug.git ~/.zplug
fi

source ~/.zplug/init.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/archive", from:prezto
zplug "modules/dpkg", from:prezto
zplug "modules/history-substring-search", from:prezto
zplug "modules/syntax-highlighting", from:prezto
zplug "modules/git", from:prezto
zplug "modules/gpg", from:prezto
zplug "modules/python", from:prezto
zplug "~/Code/dotfiles", use:"tbekolay-theme.zsh", from:local, as:theme

# Then, source plugins and add commands to $PATH
zplug load
