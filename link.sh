#!/usr/bin/env bash
WSL="grep -q Microsoft /proc/version"
declare -A TARGETS
TARGETS[nanorc.d]=.nanorc.d
TARGETS[xkb]=.xkb
TARGETS[gitconfig]=.gitconfig
TARGETS[install.apt]=.install.apt
TARGETS[nanorc]=.nanorc
TARGETS[redshift.conf]=.config/redshift.conf
TARGETS[sshconfig]=.ssh/config
TARGETS[fonts.conf]=.config/fontconfig/fonts.conf
TARGETS[Xresources]=.Xresources
TARGETS[jupyter.js]=.jupyter/custom/custom.js
TARGETS[jupyter_notebook_config.py]=.jupyter/jupyter_notebook_config.py
TARGETS[gemrc]=.gemrc
TARGETS[npmrc]=.npmrc
TARGETS[flake8]=.config/flake8
TARGETS[ignore]=.ignore
TARGETS[ripgreprc]=.ripgreprc
TARGETS[asflog.conf]=asf/NLog.config
TARGETS[zshrc]=.zshrc
# --- Mac OS X specific
if [[ $(uname) == 'Darwin' ]]; then
    TARGETS[gpg-agent.conf]=.gnupg/gpg-agent.conf
    TARGETS[gpg.conf]=.gnupg/gpg.conf
else
# --- For Debian
    TARGETS[i3.config]=.config/i3/config
    TARGETS[i3status.conf]=.i3status.conf
    TARGETS[emacs.service]=.config/systemd/user/emacs.service
    TARGETS[emacsclient.desktop]=.local/share/applications/emacsclient.desktop
    TARGETS[xsessionrc]=.xsessionrc
fi

checkandlink () {
    SRC=$1
    DST=$2
    DIR=$(dirname "$DST")

    if [ ! -d "$DIR" ]; then
        echo "--- Making directory '$DIR'"
        mkdir -p "$DIR"
    fi

    if [[ ! -h "$DST" || $(readlink "$DST") != "$SRC" ]]; then
        echo "--- Linking $DST to $SRC"
        rm -rf "$DST"
        if [[ $SRC == *".service" ]]; then
            # Special case due to systemd not allowing services to be symlinks
            ln "$SRC" "$DST"
        else
            ln -s "$SRC" "$DST"
        fi
    fi
}

for DOTFILE in "${!TARGETS[@]}"; do
    SRC="$HOME/Code/dotfiles/$DOTFILE"
    if [[ ${TARGETS[$DOTFILE]:0:1} == '/' ]]; then
        DST=${TARGETS[$DOTFILE]}
    else
        DST="$HOME/${TARGETS[$DOTFILE]}"
    fi
    checkandlink "$SRC" "$DST"
done
