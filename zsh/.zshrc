#!/usr/bin/env zsh

# Detailed Benchmarking (opt-in via ZSH_BENCHMARK=1)
if [[ -n "${ZSH_BENCHMARK:-}" ]]; then
    zmodload zsh/datetime
    _ZSH_START_TIME=$EPOCHREALTIME
    typeset -ga _ZSH_PHASE_LABELS=()
    typeset -ga _ZSH_PHASE_TIMES=()

    _profile_phase() {
        _ZSH_PHASE_LABELS+=("$1")
        _ZSH_PHASE_TIMES+=("$EPOCHREALTIME")
    }
else
    _profile_phase() { :; }
fi

exists_command () {
    command -v "$1" &>/dev/null
}

defer_run() {
    if (( $+functions[zsh-defer] )); then
        zsh-defer -t 0.1 "$@"
    else
        "$@"
    fi
}

_profile_phase "Early init"

typeset -g IS_DARWIN=0
typeset -g IS_ARM_MAC=0
[[ "$OSTYPE" == darwin* ]] && IS_DARWIN=1
[[ $IS_DARWIN -eq 1 && "$(uname -m)" == "arm64" ]] && IS_ARM_MAC=1

# Set PATH FIRST before anything else (cross-platform)
if [[ -f "/etc/paths" ]]; then
    # macOS: Read from /etc/paths without spawning tr/sed
    path=(${(f)"$(</etc/paths)"})
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
HOSTNAME="${HOST:-${HOSTNAME:-unknown}}"

# Only compute DISPLAY when it is actually missing and mostly on Linux/X11 setups
if [[ -z "$DISPLAY" ]]; then
    if [[ $IS_DARWIN -eq 1 ]]; then
        DISPLAY=":0.0"
    elif exists_command "ip"; then
        DISPLAY="$(ip -4 addr show 2>/dev/null | awk '/inet 192\.168\./ {sub(/\/.*/, "", $2); print $2; exit}')":0.0
    else
        DISPLAY=":0.0"
    fi
fi

export BAT_THEME="OneHalfDark"

_profile_phase "Environment setup"

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

_profile_phase "zinit core"

zinit ice lucid light-mode
zinit light romkatv/zsh-defer

_profile_phase "zsh-defer ready"

# zsh plugins
_profile_phase "Core plugins"

zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

_profile_phase "pure prompt"

zinit light jeffreytse/zsh-vi-mode

_profile_phase "vi mode"

# Docker CLI completions - must be BEFORE compinit
if [[ -d "$HOME/.docker/completions" ]]; then
    fpath=($HOME/.docker/completions $fpath)
fi

zinit ice lucid light-mode blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

autoload -Uz compinit
compinit -C -d ~/.zcompdump

_defer_fzf_tab_plugin() {
    zinit ice lucid light-mode
    zinit light Aloxaf/fzf-tab
}
defer_run _defer_fzf_tab_plugin

_defer_autosuggestions_plugin() {
    zinit ice lucid light-mode atload"_zsh_autosuggest_start"
    zinit light zsh-users/zsh-autosuggestions
}
defer_run _defer_autosuggestions_plugin

_defer_sudo_plugin() {
    zinit ice lucid
    zinit light OMZP::sudo
}
defer_run _defer_sudo_plugin

_defer_command_not_found_plugin() {
    zinit ice lucid
    zinit light OMZP::command-not-found
}
defer_run _defer_command_not_found_plugin

if [[ -s "$HOME/.bun/_bun" ]]; then
    defer_run source "$HOME/.bun/_bun"
fi

_profile_phase "completion stack ready"

# Override print to avoid pure precmd print calls during init
print() {
  [ 0 -eq $# -a "prompt_pure_precmd" = "${funcstack[-1]}" ] || builtin print "$@";
}

zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

_bind_fzf_history_widget() {
    (( $+widgets[fzf-history-widget] )) || return 0
    bindkey '^R' fzf-history-widget
    bindkey -M emacs '^R' fzf-history-widget
    bindkey -M viins '^R' fzf-history-widget
    bindkey -M vicmd '^R' fzf-history-widget
}

# to rewrite keybindings
zvm_after_init () {
  # Edit line in vim with ctrl-e
  autoload -z edit-command-line
  zle -N edit-command-line

  bindkey "^x^e" edit-command-line
  bindkey -M viins "^u" end-of-line
  _bind_fzf_history_widget
}

# Load fzf shell integration once keybindings, completion, and widgets are ready.
_load_fzf_shell_integration() {
    (( ${+_FZF_SHELL_INTEGRATION_LOADED} )) && return 0

    if (( $+commands[fzf] )) && fzf --zsh >/dev/null 2>&1; then
        source <(fzf --zsh)
    elif [[ -f "$HOME/.fzf.zsh" ]]; then
        source "$HOME/.fzf.zsh"
    else
        return 0
    fi

    typeset -g _FZF_SHELL_INTEGRATION_LOADED=1
    _bind_fzf_history_widget
}

bindkey -v

_profile_phase "Plugins loaded"

###########
# OPTIONS #
###########

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=$HISTSIZE
HIISTDUP=erase
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

_profile_phase "Shell options"

# Load functions early (needed by add-to-path, source_folder)
source "$HOME/.zsh_functions"

[ -f "$HOME/.profile" ] && source "$HOME/.profile"

add-to-path "MY_SCRIPTS" "$HOME/.mac_config/scripts"

# macOS-specific: LaTeX
if [[ $IS_DARWIN -eq 1 ]] && [[ -d "/Library/TeX/texbin" ]]; then
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

if [[ ! -f ~/.local/bin/fd ]] && (( $+commands[fdfind] )); then
    ln -s "${commands[fdfind]}" ~/.local/bin/fd 2>/dev/null || true
fi

if [[ ! -f ~/.local/bin/bat ]] && (( $+commands[batcat] )); then
    ln -s "${commands[batcat]}" ~/.local/bin/bat 2>/dev/null || true
fi

# Platform-specific homebrew paths
if [[ $IS_DARWIN -eq 1 ]]; then
    if [[ $IS_ARM_MAC -eq 1 ]]; then
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

# go path depending on machine
if [[ $IS_DARWIN -eq 1 ]]; then
    add-to-path "GOPATH" "/Users/$USER/go/bin"
else
    add-to-path "GOPATH" "/usr/local/go/bin"
fi

# Dagger completion (cross-platform) - defer regeneration work
if exists_command "dagger"; then
    if [[ $IS_DARWIN -eq 1 ]]; then
        DAGGER_COMP_FILE="/opt/homebrew/share/zsh/site-functions/_dagger"
        [[ ! -f "$DAGGER_COMP_FILE" ]] && DAGGER_COMP_FILE="/usr/local/share/zsh/site-functions/_dagger"
    else
        mkdir -p "$HOME/.local/share/zsh/site-functions"
        DAGGER_COMP_FILE="$HOME/.local/share/zsh/site-functions/_dagger"
        fpath=($HOME/.local/share/zsh/site-functions $fpath)
    fi

    _refresh_dagger_completion() {
        local dagger_bin="${commands[dagger]}"
        [[ -z "$dagger_bin" || -z "$DAGGER_COMP_FILE" ]] && return
        if [[ ! -f "$DAGGER_COMP_FILE" ]] || [[ "$dagger_bin" -nt "$DAGGER_COMP_FILE" ]]; then
            dagger completion zsh --quiet > "$DAGGER_COMP_FILE" 2>/dev/null
        fi
    }

    defer_run _refresh_dagger_completion
fi

export PATH

_profile_phase "Path setup"

source_folder "$DOTFILES/aliases"

_defer_obsidian_terminal() {
    [[ -d "$OBSIDIAN/terminal" ]] && source_folder "$OBSIDIAN/terminal"
}
defer_run _defer_obsidian_terminal

# Cargo lazy-load
_cargo_init() {
    unset -f cargo
    [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
}
cargo() { _cargo_init && cargo "$@"; }
rustc() { _cargo_init && rustc "$@"; }

# PURE prompt settings - optimized for speed
export PURE_CMD_MAX_EXEC_TIME=2
export PURE_PROMPT_SYMBOL=""
export PURE_PROMPT_VICMD_SYMBOL=""
export PURE_GIT_UNTRACKED_DIRTY=0
export PURE_PROMPT_EOL_MARK=""
zstyle :prompt:pure:git:fetch only_upstream yes
zstyle :prompt:pure:prompt:success color green
zstyle :prompt:pure:git:dirty color yellow
zstyle :prompt:pure:git:show-status false

# fzf settings
export FZF_DEFAULT_OPTS='--preview "bat --theme="Nord" --style=numbers --color=always --line-range :500 {}"'
export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --hidden'
export FZF_ALT_C_COMMAND='fd --hidden'

_load_fzf_shell_integration

# zoxide lazy-load (use 'c' instead of 'z' to avoid conflict with zinit)
_zoxide_init() {
    unset -f c zz zzi
    eval "$(zoxide init zsh --cmd c)"
}
c() { _zoxide_init && c "$@"; }
zz() { _zoxide_init && zz "$@"; }
zzi() { _zoxide_init && zzi "$@"; }

# luarocks lazy-load
_luarocks_init() {
    unset -f luarocks
    eval "$(luarocks path)"
}
luarocks() { _luarocks_init && luarocks "$@"; }

export KUBECONFIG=~/.kube/config

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

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

_profile_phase "Lazy loaders configured"

# Benchmarking - report startup time
if [[ -n "${ZSH_BENCHMARK:-}" && -n "$_ZSH_START_TIME" ]]; then
    typeset -F duration_ms prev_time current_time phase_ms
    typeset -i i

    duration_ms=$(( ($EPOCHREALTIME - $_ZSH_START_TIME) * 1000 ))
    prev_time=$_ZSH_START_TIME

    print -P "%F{cyan}Zsh startup profile%f"
    for (( i = 1; i <= ${#_ZSH_PHASE_LABELS[@]}; i++ )); do
        current_time=${_ZSH_PHASE_TIMES[i]}
        phase_ms=$(( (current_time - prev_time) * 1000 ))
        print -P "%F{cyan}  -> ${_ZSH_PHASE_LABELS[i]}:%f %F{yellow}${phase_ms}ms%f"
        prev_time=$current_time
    done
    phase_ms=$(( ($EPOCHREALTIME - prev_time) * 1000 ))
    print -P "%F{cyan}  -> Finalization:%f %F{yellow}${phase_ms}ms%f"
    print -P "%F{cyan}Total shell startup:%f %F{green}${duration_ms}ms%f"

    unset _ZSH_START_TIME
    unset _ZSH_PHASE_LABELS
    unset _ZSH_PHASE_TIMES
fi
