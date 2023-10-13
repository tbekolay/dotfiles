#
# A simple theme that displays relevant, contextual information.
# Particularly suited for those making heavy use of git and Python.
#
# Authors:
#   Trevor Bekolay <tbekolay@gmail.com>
#   John Stevenson <john@jr0cket.co.uk>
#

# Load dependencies.
pmodload 'helper'

prompt_tbekolay_pwd() {
  local pwd="${PWD/#$HOME/~}"

  if [[ "$pwd" == (#m)[/~] ]]; then
    _prompt_tbekolay_pwd="$MATCH"
    unset MATCH
  else
    _prompt_tbekolay_pwd="${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}/${pwd:t}"
  fi
}

prompt_tbekolay_precmd() {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS

  # Format PWD.
  prompt_tbekolay_pwd

  # Get Git repository information.
  if (( $+functions[git-info] )); then
      git-info
  fi

  # Get Python virtualenv information.
  if (( $+functions[python-info] )); then
      python-info
  fi

  # Get NodeJS information.
  if (( $+functions[node-info] )); then
      node-info
  fi
}

prompt_tbekolay_setup() {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  # Load required functions.
  autoload -Uz add-zsh-hook

  # Add hook for calling *-info before each command.
  add-zsh-hook precmd prompt_tbekolay_precmd

  # Indicate if the editor is completing
  zstyle ':prezto:module:editor:info:completing' format '%B%F{red}...%f%b'

  # Set git-info parameters
  zstyle ':prezto:module:git:info:action' format ':%%B%F{yellow}%s%f%%b'
  zstyle ':prezto:module:git:info:added' format ' %%B%F{green}✚%f%%b'
  zstyle ':prezto:module:git:info:ahead' format ' %%B%F{yellow}⬆%f%%b'
  zstyle ':prezto:module:git:info:behind' format ' %%B%F{yellow}⬇%f%%b'
  zstyle ':prezto:module:git:info:branch' format '%F{green}%b%f'
  zstyle ':prezto:module:git:info:commit' format '%F{green}%.7c%f'
  zstyle ':prezto:module:git:info:deleted' format ' %%B%F{red}✖%f%%b'
  zstyle ':prezto:module:git:info:modified' format ' %%B%F{blue}✱%f%%b'
  zstyle ':prezto:module:git:info:position' format '%F{red}%p%f'
  zstyle ':prezto:module:git:info:renamed' format ' %%B%F{magenta}➜%f%%b'
  zstyle ':prezto:module:git:info:stashed' format ' %%B%F{cyan}✭%f%%b'
  zstyle ':prezto:module:git:info:unmerged' format ' %%B%F{yellow}═%f%%b'
  zstyle ':prezto:module:git:info:untracked' format ' %%B%F{white}◼%f%%b'

  # Set python-info parameters
  zstyle ':prezto:module:python:info:virtualenv' format \
      ' %F{blue}(%f%F{grey}%v%f%F{blue})%f'

  # How attributes will be displayed in prompts
  zstyle ':prezto:module:git:info:keys' format \
      'rprompt' \
      '%F{blue}(%f$(coalesce "%b" "%p" "%c")%s%F{blue})%f %A%B%S%a%d%m%r%U%u'

  # Disable python virtualenv environment prompt prefix
  VIRTUAL_ENV_DISABLE_PROMPT=1

  # Define prompts.
  PROMPT='%F{yellow}${_prompt_tbekolay_pwd}%f${python_info:+${(e)python_info[virtualenv]}}${node_info:+${(e)node_info[version]}}%(!. %B%F{red}#%f%b.) '
  RPROMPT='%(?:: %F{red}⏎%f) ${git_info:+${(e)git_info[rprompt]}}'
  SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
}

prompt_tbekolay_setup "$@"
