#!/usr/bin/env zsh

exists_command () {
    command -v "$1" &>/dev/null
}

# Set PATH FIRST before anything else (cross-platform)
if [[ -f "/etc/paths" ]]; then
    # macOS: Read from /etc/paths
    PATH=$(tr "\n" ":" < "/etc/paths" | sed 's/.\{1\}$//')
else
    # Linux: Set standard PATH
    mkdir -p "$HOME/.local/bin"
    PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
fi
export PATH

# Locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export EDITOR="nvim"
DOTFILES="$HOME/.mac_config"
OBSIDIAN="$HOME/personal/obsidian"
PALETTES="$DOTFILES/palettes"
HOSTNAME=$(hostname 2>/dev/null || echo "unknown")
TERM="screen-256color"

# Get display IP (cross-platform)
if exists_command "ifconfig"; then
    # macOS/BSD style
    DISPLAY=$(ifconfig 2>/dev/null | grep -E "192\.168\.[0-9]{1,3}\.[0-9]{1,3}" | awk '{print $2}' | head -1):0.0
elif exists_command "ip"; then
    # Linux style
    DISPLAY=$(ip addr 2>/dev/null | grep -oE "192\.168\.[0-9]{1,3}\.[0-9]{1,3}" | head -1):0.0
else
    DISPLAY=":0.0"
fi

export BAT_THEME="OneHalfDark"

#########
# ZINIT #
#########

# zinit install
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# zsh plugins - with turbo mode for faster startup
zinit wait lucid light-mode for \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab

zinit wait lucid for \
    OMZP::sudo \
    OMZP::command-not-found

# Defer expensive compinit - will be called by zinit in background
# This makes shell interactive faster
autoload -Uz compinit
compinit -C -d ~/.zcompdump

zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# to rewrite keybindings
zvm_after_init () {
  # Edit line in vim with ctrl-e
  autoload -z edit-command-line
  zle -N edit-command-line

  bindkey "^x^e" edit-command-line
  bindkey -M viins "^u" end-of-line

  [ -f ~/.fzf.zsh ] && source "$HOME/.fzf.zsh"

  # fzf key bindings (check if --zsh flag is supported)
  if fzf --zsh &>/dev/null; then
    source <(fzf --zsh)
  fi
}

bindkey -v

###########
# OPTIONS #
###########

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=$HISTSIZE
HIISTDUP=erase
setopt autocd notify
setopt append_history
setopt extended_glob
setopt share_history
setopt inc_append_history
unsetopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_verify
setopt hist_reduce_blanks
unsetopt beep extendedglob nomatch

source "$HOME/.zsh_functions"
source "$HOME/.profile"

# add-to-path "JAVA_HOME" "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home" "bin"
# add-to-path "OPENSSL_HOME" "/usr/local/opt/openssl@3.0" "bin"
# add-to-path "PET_HOME" "$HOME/pet"
add-to-path "MY_SCRIPTS" "$HOME/.mac_config/scripts"

# macOS-specific: LaTeX
if [[ "$(uname)" == "Darwin" ]] && [[ -d "/Library/TeX/texbin" ]]; then
    add-to-path "LTX_HOME" "/Library/TeX" "/texbin"
fi

# Cross-platform: Cargo (Rust)
if [[ -d "$HOME/.cargo/bin" ]]; then
    add-to-path "CARGO_HOME" "$HOME/.cargo" "bin"
fi

# Optional: Obsidian scripts
if [[ -d "$OBSIDIAN/terminal/scripts" ]]; then
    add-to-path "OBSIDIAN_SCRIPTS" "$OBSIDIAN/terminal/scripts"
fi

if [[ ! -f ~/.local/bin/fd ]]; then
    ln -s $(which fdfind) ~/.local/bin/fd 2>/dev/null || true
fi

if [[ ! -f ~/.local/bin/bat ]]; then
    ln -s $(which batcat) ~/.local/bin/bat 2>/dev/null || true
fi

# Platform-specific homebrew paths
if [[ "$(uname)" == "Darwin" ]]; then
    if [[ "$(uname -p)" == "arm" ]]; then
        add-to-path "LOCAL_BIN" "$HOME/.local/bin"
        add-to-path "HOMEBREW" "/opt/homebrew" "/bin"
    else
        add-to-path "HOMEBREW" "/usr/local/Homebrew" "/bin"
    fi
else
    # Linux: add local bin if exists
    if [[ -d "$HOME/.local/bin" ]]; then
        add-to-path "LOCAL_BIN" "$HOME/.local/bin"
    fi
fi

PATH=$PATH:$(go env GOPATH)/bin

# Dagger completion (cross-platform) - cached for performance
if exists_command "dagger"; then
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS with Homebrew
        DAGGER_COMP_FILE="/opt/homebrew/share/zsh/site-functions/_dagger"
        [[ ! -f "$DAGGER_COMP_FILE" ]] && DAGGER_COMP_FILE="/usr/local/share/zsh/site-functions/_dagger"

        # Regenerate only if missing or dagger binary is newer
        if [[ ! -f "$DAGGER_COMP_FILE" ]] || [[ "$(command -v dagger)" -nt "$DAGGER_COMP_FILE" ]]; then
            dagger completion zsh --quiet > /opt/homebrew/share/zsh/site-functions/_dagger 2>/dev/null || \
            dagger completion zsh --quiet > /usr/local/share/zsh/site-functions/_dagger 2>/dev/null
        fi
    else
        # Linux: use user's local zsh functions directory
        mkdir -p "$HOME/.local/share/zsh/site-functions"
        DAGGER_COMP_FILE="$HOME/.local/share/zsh/site-functions/_dagger"

        # Regenerate only if missing or dagger binary is newer
        if [[ ! -f "$DAGGER_COMP_FILE" ]] || [[ "$(command -v dagger)" -nt "$DAGGER_COMP_FILE" ]]; then
            dagger completion zsh --quiet > "$DAGGER_COMP_FILE" 2>/dev/null
        fi
        fpath=($HOME/.local/share/zsh/site-functions $fpath)
    fi
fi

export PATH

source_folder "$DOTFILES/aliases"
source_folder "$OBSIDIAN/terminal"

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
# source "$HOME/.aws-tokens"

export STARSHIP_CONFIG=~/.config/starship/starship.toml
export FZF_DEFAULT_OPTS='--preview "bat --theme="Nord" --style=numbers --color=always --line-range :500 {}"'
export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --hidden'
export FZF_ALT_C_COMMAND='fd --hidden'

# eval "$(starship init zsh)"

# prmt - simple prompt
setopt PROMPT_SUBST
if exists_command "prmt"; then
    PROMPT='$(prmt --code $? "{path:cyan} {git:purple} \n{ok:green:✓}{fail:red:✗} ")'
fi
# zoxide: use --cmd to rename commands to avoid zi conflict with zinit (creates zz/zzi instead of z/zi)
exists_command "zoxide" && eval "$(zoxide init zsh --cmd c)"
exists_command "luarocks" && eval "$(luarocks path)"

# source $(brew --cellar fzf)/**/key-bindings.zsh

export LUA_PATH="$LUA_PATH;/usr/local/lib/lua/5.4/?.so"

# NVM lazy loading for faster startup
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # Add nvm's bin to PATH without loading nvm
    export PATH="$NVM_DIR/versions/node/$(cat $NVM_DIR/alias/default 2>/dev/null || echo 'v20.0.0')/bin:$PATH"

    _load_nvm() {
        unset -f nvm node npm npx _load_nvm
        \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    }

    # Lazy load nvm when called
    nvm() { _load_nvm && nvm "$@" }
    node() { _load_nvm && node "$@" }
    npm() { _load_nvm && npm "$@" }
    npx() { _load_nvm && npx "$@" }
fi

# Docker CLI completions (cross-platform)
if [[ -d "$HOME/.docker/completions" ]]; then
    fpath=($HOME/.docker/completions $fpath)
fi

# Ruby version manager (macOS with Homebrew) - lazy loaded
if [[ -f "/opt/homebrew/opt/chruby/share/chruby/chruby.sh" ]]; then
    # Add ruby to PATH without loading chruby (faster)
    if [[ -d "/opt/homebrew/opt/ruby/bin" ]]; then
        export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    fi

    # Helper function to load chruby once
    _load_chruby() {
        unset -f chruby ruby gem bundle _load_chruby
        source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
        source /opt/homebrew/opt/chruby/share/chruby/auto.sh
    }

    # Lazy load wrappers
    chruby() { _load_chruby && chruby "$@"; }
    ruby() { _load_chruby && ruby "$@"; }
    gem() { _load_chruby && gem "$@"; }
    bundle() { _load_chruby && bundle "$@"; }
fi

# opencode (if installed)
[ -d "$HOME/.opencode/bin" ] && export PATH=$HOME/.opencode/bin:$PATH
