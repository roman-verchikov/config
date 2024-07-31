for rcfile in ~/.bashrc.rc/*; do
    source ${rcfile}
done

LS_COMMAND="ls --color --group-directories-first"

export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export BAT_THEME="GitHub"

[[ -d /Applications/PyCharm.app/Contents/MacOS ]] && export PATH=/Applications/PyCharm.app/Contents/MacOS:$PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"

  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi

  export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/openssl@1.1/lib"
  export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/openssl@1.1/include"
fi

use_gnu() {
    local cmd="${1}"

    if which g${cmd} > /dev/null; then
        echo "g${cmd}"
        return
    fi

    echo "${cmd}"
}

GNU_LS_OPTIONS='--color --group-directories-first -v'

if [[ ${OSTYPE} == "darwin"* ]]; then
    alias sed=$(use_gnu sed)
    alias ls=$(use_gnu ls)
    alias awk=$(use_gnu awk)
    alias grep=$(use_gnu grep)

    if which gls > /dev/null; then
        alias ls="gls ${GNU_LS_OPTIONS}"
    else
        alias ls='ls -G'
    fi
fi

if [[ ${OSTYPE} == "linux-gnu"* ]]; then
    alias ls="ls ${GNU_LS_OPTIONS}"
fi

alias ll='ls -lAh'
alias la='ls -a'
alias l='ls'

alias ssh='ssh -A'
alias df='df -h'
alias du='du -h'
alias gs='git status'
alias config="/usr/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}"

# cloudlabs has dependency on pycurl, and `pip install pycurl` fails with
#
# ```
# Collecting pycurl (from -r requirements.txt (line 17))
# Downloading https://files.pythonhosted.org/packages/e8/e4/0dbb8735407189f00b33d84122b9be52c790c7c3b25286826f4e1bdb7bde/pycurl-7.43.0.2.tar.gz (214kB)
#    100% |████████████████████████████████| 215kB 3.4MB/s
#    Complete output from command python setup.py egg_info:
#    Using curl-config (libcurl 7.54.0)
#    Traceback (most recent call last):
#      File "<string>", line 1, in <module>
#      File "/private/var/folders/5t/zp39rf7n7p1crlhqhg9_my8m0000gn/T/pip-install-9pm5q115/pycurl/setup.py", line 913, in <module>
#        ext = get_extension(sys.argv, split_extension_source=split_extension_source)
#      File "/private/var/folders/5t/zp39rf7n7p1crlhqhg9_my8m0000gn/T/pip-install-9pm5q115/pycurl/setup.py", line 582, in get_extension
#        ext_config = ExtensionConfiguration(argv)
#      File "/private/var/folders/5t/zp39rf7n7p1crlhqhg9_my8m0000gn/T/pip-install-9pm5q115/pycurl/setup.py", line 99, in __init__
#        self.configure()
#      File "/private/var/folders/5t/zp39rf7n7p1crlhqhg9_my8m0000gn/T/pip-install-9pm5q115/pycurl/setup.py", line 316, in configure_unix
#        specify the SSL backend manually.''')
#    __main__.ConfigurationError: Curl is configured to use SSL, but we have not been able to determine which SSL backend it is using. Please see PycURL documentation for how to specify the SSL backend manually.
#```
#
# In order to resolve, specify SSL backend explicitly with exports below.
#
# https://github.com/pycurl/pycurl/issues/526

export PYCURL_SSL_LIBRARY=openssl

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


complete -C $(brew --prefix)/bin/terraform terraform

if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

export PATH="/usr/local/opt/node@14/bin:$PATH"

if command -v pipenv &> /dev/null; then
  eval "$(_PIPENV_COMPLETE=bash_source pipenv)"
fi

# GOLANG
export GOPATH=/Users/rverchykov/go
export GOROOT=${GOPATH}/sdk/go1.18.2
export PATH=${GOROOT}/bin:${GOPATH}/bin:${PATH}

# k8s
source <(kubectl completion bash)
alias k=kubectl

if command -v helm 1>/dev/null 2>&1; then
  source <(helm completion bash)
fi

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

