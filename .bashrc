for rcfile in ~/.bashrc.rc/*; do
    source ${rcfile}
done

LS_COMMAND="ls --color --group-directories-first"

export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export BAT_THEME="GitHub"

# needed for homebrew
[[ -d /usr/local/bin ]] && export PATH=/usr/local/bin:$PATH
[[ -d /usr/local/sbin ]] && export PATH=/usr/local/sbin:$PATH

gnu_utils=(sed ls awk grep)

for util in ${gnu_utils[*]}; do
    if [[ -f $(which g${util}) ]]; then
        alias $util=g$util
    fi
done

if [[ ! -f $(which gls) ]]; then
    LS_COMMAND="ls -G"
else
    LS_COMMAND=g$LS_COMMAND
fi

alias ls=$LS_COMMAND
alias ll='ls -lAh'
alias la='ls -a'
alias l='ls'
alias ssh='ssh -A'
alias df='df -h'
alias du='du -h'
alias cat=bat
alias gs='git status'
alias config='/usr/bin/git --git-dir=/Users/roman/.cfg/ --work-tree=/Users/roman'

[[ -f ~/.bashrc.apstra ]] && source ~/.bashrc.apstra

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end


# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

