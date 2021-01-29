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
alias gs='git status'
alias config='/usr/bin/git --git-dir=/Users/roman/.cfg/ --work-tree=/Users/roman'

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
export LDFLAGS=-L/usr/local/opt/openssl/lib
export CPPFLAGS=-I/usr/local/opt/openssl/include

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


alias django-admin="docker run \
		--rm \
		--user `id -u` \
		--env "DJANGO_SETTINGS_MODULE=cloudlabs.settings" \
		--env "PYTHONPATH=/code" \
		--env CLOUDLABS_ENVIRONMENT=development \
		--volume /Users/roman/Documents/apstra/cloudlabs-portal/:/code \
		cloudlabs_django:local \
		django-admin"

alias php="docker run -v $(pwd):/cwd -w /cwd --rm php"

complete -C /usr/local/bin/terraform terraform
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
