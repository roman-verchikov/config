LS_COMMAND="ls --color --group-directories-first"
GREP_COMMAND=grep

if [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
fi

function is_installed() {
    hash ${1} &>/dev/null
}

[[ -d /usr/local/bin ]] && export PATH=/usr/local/bin:$PATH
# needed for homebrew
[[ -d /usr/local/sbin ]] && export PATH=/usr/local/sbin:$PATH

export EDITOR=vim
case $(uname) in
    Darwin) [[ -f ~/.bashrc.osx ]] && source ~/.bashrc.osx ;;
    Cygwin) [[ -f ~/.bashrc.cygwin ]] && source ~/.bashrc.cygwin ;;
    Linux) [[ -f ~/.bashrc.linux ]] && source ~/.bashrc.linux ;;
esac

# add some colors to the prompt
username="\[$(tput setaf 2)\]\u\[$(tput sgr0)\]"
hostname="\[$(tput setaf 5)\]\h\[$(tput sgr0)\]"
workdir="\[$(tput setaf 4)\]\W\[$(tput sgr0)\]"
dollarsign="\[$(tput setaf 4)\]\$\[$(tput sgr0)\]"

gitbranch=''
if is_installed __git_ps1; then
    # Don't use __git_ps1 when it's painfully slow or failing
    # see https://gist.github.com/bps/883177
    git_status=$(__git_ps1 "(%s)")
    [[ $? != 130 ]] && gitbranch='\[$(tput setaf 6)\]$(__git_ps1)\[$(tput sgr0)\]'
else
    echo '__git_ps1 is not installed! You may probably want to install git completion' 1>&2
fi

export PS1="${username}@${hostname} ${workdir}${gitbranch} ${dollarsign} "

# Syntax highligh for GNU less
if is_installed src-hilite-lesspipe.sh; then
    export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s"
    export LESS='-R'
fi

alias ls=$LS_COMMAND
alias ll='ls -lAh'
alias la='ls -a'
alias l='ls'
alias ssh='ssh -A'
alias df='df -h'
alias du='du -h'
alias grep="$GREP_COMMAND --color"

if [[ -f ~/.bashrc.local ]]; then
    source ~/.bashrc.local
fi

function no_comments() {
    local file=$1
    sed -r '/(#.*)|(^\s*$)/d' $file
}

function git_log() {
    local branch=$1
    local depth=${2:-50}

    git log -n "${depth}" --oneline "${branch}" | sed -E 's/^[0-9a-z]{7} //'
}

function copy_over_ssh() {
    # Copies compressed dir over SSH and unpacks it remotely
    #
    # Usage:
    #   copy_over_ssh REMOTE [LOCAL_PATH] [REMOTE_PATH]
    local remote=$1
    local local_path=${2:-.}
    local remote_path=${3:-/tmp}
    local usage=$(cat << EOF
Copies compressed dir over SSH and unpacks it remotely

Usage:
  copy_over_ssh REMOTE [LOCAL_PATH] [REMOTE_PATH]
EOF
)

    [[ -z $remote ]] && echo "$usage" && return

    tar -cf - $local_path | ssh $remote "(cd ${remote_path}; tar -xpf -)"
}

export GOPATH="${HOME}/Documents/golang"

[[ ! -d "${GOPATH}" ]] && mkdir -p "${GOPATH}"
export PATH=${GOPATH}/bin:${PATH}

export NVM_DIR="/Users/rverchikov/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -f ~/.bashrc.apstra ]] && source ~/.bashrc.apstra

alias config='/usr/bin/git --git-dir=/Users/roman/.cfg/ --work-tree=/Users/roman'
