# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/opt/flex/bin:/usr/local/opt/gettext/bin:$HOME/opt/bin:$HOME/opt/cross/bin:$PATH"


# Path to your oh-my-zsh installation.
export ZSH=/Users/amarkon/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

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
plugins=(
  git
  globalias
)

source $ZSH/oh-my-zsh.sh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd nomatch
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/adam/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

DEFAULT_USER=amarkon

alias vi="vim"
alias gs="git status"
alias gb="git branch"
alias gnb="git checkout -b adam/"
alias gco="git commit -a"
alias gcoa="git commit -a --amend --no-edit"
alias gd="git diff"
alias gda="git diff --staged"
alias gl="git log"
alias gds="git diff --stat"
alias stash="git stash save"
alias pop="git stash pop"
alias la="ls -al"
alias up="cd .."
alias g="cd ~/git"
alias up="cd .."
alias zp="vi ~/.zshrc"
alias tmp="git add . && git commit -m 'tmp'"
alias untmp="git reset HEAD~1"
alias docker-clean="docker run --rm --net=host --pid=host --privileged -it justincormack/nsenter1 /sbin/fstrim /var/lib"
alias crm="cd ~/git/HubSpot/CRM"
alias prod-build="NODE_ARGS=\"--max-old-space-size=5192\" bend reactor build all --mode production --update"
alias tmux="tmux -2"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

function brs () {
  if [ "$1" = "" ]; then
    NODE_ARGS='--max_old_space_size=8192' bend reactor serve . --update;
  else
    NODE_ARGS='--max_old_space_size=8192' bend reactor serve $@ --update;
  fi
}

function start-crm () {
  if [ "$1" = "" ]; then
    cd ~/git/HubSpot/CRM;
    NODE_ARGS='--max_old_space_size=6144' bend reactor serve crm_ui crm_components crm_data crm_internal crm_schema --update;
  else
    NODE_ARGS='--max_old_space_size=6144' bend reactor serve $@ --update;
  fi
}

pull () {
  current_branch=$(git symbolic-ref --short HEAD);
  if [ $current_branch = "master" ]; then
    git pull --rebase --autostash;
  else
    git pull origin `git symbolic-ref --short HEAD` --rebase --autostash;
  fi
}
push () {
  git push origin `git symbolic-ref --short HEAD` $@;
}
yolo () {
  git push origin `git symbolic-ref --short HEAD` --no-verify -ff;
}

_gch_comp() {
  reply=(`git branch | grep adam`);
}

compctl -K _gch_comp gch
compctl -K _gch_comp gre

function gch() {
  if [ "$1" = "-b" ]; then
    git checkout -b "adam/$2";
  else
    git checkout "$1";
  fi
}

gre () {
  if [ $1 = "-a" ]; then
    git rebase --autostash $2;
  elif [ $1 = "-m" ]; then
    git pull --rebase origin master;
  else
    git rebase $@
  fi
}

function trace-dep() {
  bpm dependencies --path $1 $2
}

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^r' history-incremental-search-backward

export HUB_PROTOCOL=ssh

command_not_found_handler() {
  # Do not run within a pipe
  if test ! -t 1; then
    >&2 echo "command not found: $1"
    return 127
  fi
  if which npx > /dev/null; then
    echo "$1 not found. Trying with npx..." >&2
  else
    return 127
  fi
  if ! [[ $1 =~ @ ]]; then
    npx --no-install "$@"
  else
    npx "$@"
  fi
  return $?
}

eval $(thefuck --alias)

#1password
#eval $(op signin my)

# ssh-agent
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

# open pr page for current branch
pr () {
  REMOTE_BRANCH=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
  REMOTE_NAME=$(echo $REMOTE_BRANCH | cut -d '/' -f1)
  REMOTE_URL=$(git remote get-url $REMOTE_NAME);
  BRANCH=$(echo $REMOTE_BRANCH | cut -d '/' -f2);
  open ${REMOTE_URL%.*}/compare/${BRANCH}\?expand=1
}

# get yesterdays PRs
yesterday-prs () {
  DATE=`date -v-1d +%Y-%m-%d`
  USERNAME=`git config user.email | cut -d '@' -f1`
  GIT_URL=`git remote get-url origin | grep -o '[@][A-Za-z\.]*' | cut -d'@' -f2`
  open "https://"${GIT_URL}"/search?q=author%3A"${USERNAME}"+type%3Apr+merged%3A%3E%3D"${DATE}"&type=Issues"
}

# get the last 7 days worth of PRs
fifteen-five () {
  DATE=`date -v-7d +%Y-%m-%d`
  USERNAME=`git config user.email | cut -d '@' -f1`
  GIT_URL=`git remote get-url origin |  grep -o '[@][A-Za-z\.]*' | cut -d'@' -f2`
  open "https://"${GIT_URL}"/search?q=author%3A"${USERNAME}"+type%3Apr+merged%3A%3E%3D"${DATE}"&type=Issues"
}

# merge from updated master branch
merge-master () {
  BRANCH=`git branch | grep "*" | cut -d " " -f2`
  git checkout master
  git pull
  git checkout $BRANCH
  git merge master
}

# Set to the directory you typically clone your git repos
CODE_DIR=$HOME/git/HubSpot

# Completion for repo
_repo_comp() {
  reply=(`ls $CODE_DIR`);
}

function repo() {
  if [ ! -d "$CODE_DIR/$1" ]; then
    echo Repo missing: $1
    cd $CODE_DIR
    git clone "git@git.hubteam.com:HubSpot/$1.git" || git clone "git@git.hubteam.com:HubSpotProtected/$1.git"
  fi

  cd $CODE_DIR/$1
}

compctl -K _repo_comp repo

. ~/.hubspot/shellrc
