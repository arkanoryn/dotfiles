# Path to your oh-my-zsh installation.
export ZSH=~/.dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="powerlevel9k/powerlevel9k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration


#############################
#
#   My Powerline prompt
#
#############################


POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%{%F{249}%}\u250f"
# POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="%{%F{249}%}\u2517%{%F{default}%} "


POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_MODE='awesome-patched'


######
## RSpec
######
POWERLEVEL9K_RSPEC_STATS_GOOD_FOREGROUND='blue'
POWERLEVEL9K_RSPEC_STATS_GOOD_BACKGROUND='green'
POWERLEVEL9K_RSPEC_STATS_AVG_FOREGROUND='black'
POWERLEVEL9K_RSPEC_STATS_AVG_BACKGROUND='cyan'
POWERLEVEL9K_RSPEC_STATS_BAD_FOREGROUND='red'
POWERLEVEL9K_RSPEC_STATS_BAD_BACKGROUND='white'

######
## Battery
######
#POWERLEVEL9K_BATTERY_ICON='SERVER_ICON'
#POWERLEVEL9K_BATTERY_CHARGING='yellow'
#POWERLEVEL9K_BATTERY_CHARGED='green'
#POWERLEVEL9K_BATTERY_DISCONNECTED='$DEFAULT_COLOR'
#POWERLEVEL9K_BATTERY_LOW_THRESHOLD='10'
#POWERLEVEL9K_BATTERY_LOW_COLOR='red'
#POWERLEVEL9K_BATTERY_ICON=''

POWERLEVEL9K_TIME_FOREGROUND='255'
POWERLEVEL9K_TIME_BACKGROUND='black'

# Colorize only the visual identifier
POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="green"

POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S}"

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time_joined battery)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(background_jobs context_joined dir vcs)

export PATH=":/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/Ghostscript/bin:/opt/ImageMagick/bin"
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi


source $ZSH/oh-my-zsh.sh

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
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


alias la="ls -la"
alias mi="mvim"
alias ni="nvim"
alias ne="emacs $@ &"
