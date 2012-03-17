# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
. $HOME/.ssh/ssh-login

export TERM=screen-256color

export EDITOR='vim'
export PAGER=less
export LESS='-S -R'
export GREP_OPTIONS='--color=auto'
export LS_OPTIONS='-b --color=auto'

export HISTCONTROL=erasedups
export HISTFILE=$HOME/.bash_history
export HISTFILESIZE=50000
export HISTIGNORE=
export HISTSIZE=50000
export HISTTIMEFORMAT="%a %b %Y %T %z "

typeset -r HISTCONTROL
typeset -r HISTFILE
typeset -r HISTFILESIZE
typeset -r HISTIGNORE
typeset -r HISTSIZE
typeset -r HISTTIMEFORMAT

shopt -s histappend
shopt -s cmdhist

export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
#typeset -r PROMPT_COMMAND

export PYTHONPATH=$PYTHONPATH
export PYTHONSTARTUP=~/.pythonrc
export WORKON_HOME="$HOME/.virtualenvs"
source /usr/local/bin/virtualenvwrapper.sh

# If not running interactively, don't do anything
[ -z "$PS1" ] && return
eval "`dircolors -b`"

#export PS1='\[\033[0;35m\]\h\[\033[0;33m\] \w\[\033[00m\]'`hostname`:`ifconfig|grep Bcast|awk ' { print $2 }'|awk -F":" ' { print $2 }'`'$ '

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
## set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=no;;
#esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=no

#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#        # We have color support; assume it's compliant with Ecma-48
#        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#        # a case would tend to support setf rather than setaf.)
#        color_prompt=no
#    else
#        color_prompt=
#    fi
#fi

        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

#function bash_git_branch {
#    git branch 2> /dev/null | grep \* | python -c "print '['+raw_input()[2:]+']'" 2> /dev/null
#}

function set_virtualenv {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${BLUE}(`basename \"$VIRTUAL_ENV\"`)${COLOR_NONE} "
  fi
}

function parse_git_branch {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"

  if [[ ! ${git_status}} =~ "working directory clean" ]]; then
    state="${RED}⚡"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
    else
      remote="${YELLOW}↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    echo "${branch}${remote}${state}"
  fi
}

function git_dirty_flag {
  git status 2> /dev/null | grep -c "dated:" | awk '{if ($1 > 0) print "⚡"}'
}

#if [ "$color_prompt" = yes ]; then
##PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\w$(bash_git_branch)\$ '
##PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\w\[\033[01;34m\]$(bash_git_branch)\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
bash_prompt() {
  set_virtualenv
  PS1="${debian_chroot:+($debian_chroot)}${PYTHON_VIRTUALENV}${LIGHT_GREEN}\u@\h${COLOR_NONE}:\w${BLUE} ${GREEN}[$(parse_git_branch)${GREEN}]${COLOR_NONE} \$ "
}
PROMPT_COMMAND=bash_prompt
unset color_prompt force_color_prompt
## If this is an xterm set the title to user@host:dir

#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# some more ls aliases
alias ack='ack-grep --type=python'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls="ls $LS_OPTIONS"
alias gf='find | grep -v \.pyc$ | grep'
alias ggf='git ls-files | grep'
alias p88='git diff --name-only HEAD^ | grep .py | xargs pep8'
alias p8='git diff --name-only HEAD | grep .py | xargs pep8'
alias pgfouine='~/pgfouine-1.2/pgfouine.php -file /var/log/pgsql > ~/pgfouine-1.2/index.html;google-chrome ~/pgfouine-1.2/index.html'

alias nx='sudo /usr/NX/bin/nxserver --status'

alias fixssh='source ~/bin/fixssh'

alias xrd='xrdb -merge /home/eapen/.Xresources'
#alias tmux='tmux -2'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# autocomplete ssh from bash_history
complete -W "$(echo $(grep '^ssh ' ~/.bash_history | sort -u | sed 's/^ssh //'))" ssh

source $HOME/.bashrc_private
source $HOME/.git_completion