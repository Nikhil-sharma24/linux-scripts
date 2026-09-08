# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

eval "$(zoxide init bash)"

# Path to your oh-my-bash installation.
export OSH='/home/nikhil/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="font"

# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
# You can also specify the list from which a theme is randomly selected:
# OMB_THEME_RANDOM_CANDIDATES=("font" "powerline-light" "minimal")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# To enable/disable Spack environment information
# OMB_PROMPT_SHOW_SPACK_ENV=true  # enable
# OMB_PROMPT_SHOW_SPACK_ENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

# If you want to reduce the initialization cost of the "tput" command to
# initialize color escape sequences, you can uncomment the following setting.
# This disables the use of the "tput" command, and the escape sequences are
# initialized to be the ANSI version:
#
#OMB_TERM_USE_TPUT=no

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"
alias nd='npm run dev'
alias ns='npm start'
alias zs="code ~/.bashrc"
alias zsv="cursor ~/.vrya_aliases"
alias zss="source ~/.bashrc"
alias gedit="gnome-text-editor"
alias sedit='sudo -E gnome-text-editor'
alias ca='~/Desktop/linux_scripts/createAlias.sh'

# linux utils
alias cpwd='pwd | wl-copy'

export EDITOR="code --wait"
export VISUAL="code --wait"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

THEME_SHOW_CLOCK="false"
function _omb_theme_PROMPT_COMMAND() {
    local RC="$?"
    local python_venv; _omb_prompt_get_python_venv
    python_venv=$_omb_prompt_white$python_venv
    local spack_env; _omb_prompt_get_spack_env
    spack_env=$_omb_prompt_white$spack_env
    if [[ ${RC} == 0 ]]; then
        ret_status="${_omb_prompt_bold_green}"
    else
        ret_status="${_omb_prompt_bold_brown}"
    fi
    history -a
    PS1="$spack_env$python_venv${_omb_prompt_bold_teal}\W $(scm_prompt_char_info)${ret_status}→ ${_omb_prompt_normal}"
}

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/home/nikhil/Downloads/go1.26.3.linux-amd64/go/bin"
alias sql='sudo -u postgres psql;'
alias bkup='cp ~/.bashrc ~/.vrya_aliases ~/Desktop/linux_scripts/;'
alias pg="PGPASSWORD='admin' psql -U admin -d postgres -h localhost"
alias check-storage='sudo ncdu ~/;'
alias nr='npm run;'
alias set-opacity="dconf write "/org/gnome/Ptyxis/Profiles/$(dconf read /org/gnome/Ptyxis/default-profile-uuid | tr -d "'")/opacity""
alias check-space='ncdu /;'
alias ds='sudo systemctl start docker'
alias dstop='sudo systemctl stop docker && sudo systemctl stop docker.service && sudo systemctl stop docker.socket'
alias python='python3';
alias py='python3';

# Prompt: hide clock (time) and user@host segments from the "font" theme.
# Overrides run after oh-my-bash loads, so they survive theme updates.

alias zsc='cursor ~/.bashrc';
alias bk='./bk.sh';
alias delss='rm ~/Pictures/Screenshots/*';
alias reconnect-earphones='echo -n "0000:03:00.3" | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind; sleep 3; echo -n "0000:03:00.3" | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind';
alias check-earphones='pactl list short sinks';

# Vrya / Invoice Connect aliases live in ~/.vrya_aliases
[ -f ~/.vrya_aliases ] && source ~/.vrya_aliases
