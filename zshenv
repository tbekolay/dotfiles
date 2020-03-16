path=(
    $HOME/bin
    $HOME/.npm/bin
    $HOME/.cargo/bin
    $(gem env gempath | cut -d : -f 1)/bin
    /usr/local/{bin,sbin}
    $path
)

# --- Mac OS X specific
if [[ $(uname) == 'Darwin' ]]; then
    path=(
        '/usr/local/opt/python/libexec/bin'
        $path
    )
fi
