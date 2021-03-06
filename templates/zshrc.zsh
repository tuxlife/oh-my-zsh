loading() { print -n ${(r:$COLUMNS-2-$#1:: :):-loading $1...}'\r' }
is_root_shell() { [[ $USER == root ]] }
zstyle :omz:plugins:ssh-agent agent-forwarding on
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="random"
#ZSH_THEME=""
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#ZSH_THEME="garyblessington"
#ZSH_THEME="gnzh"
#ZSH_THEME="aussiegeek"
#ZSH_THEME="af-magic"
ZSH_THEME="mkerk"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often to auto-update? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to the command execution time stamp shown 
# in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# gpg-agent
plugins=(gpg gpg-agent command-not-found encode64 fabric jira perl python screen svn )

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

export EDITOR='vim'
# # Preferred editor for local and remote sessions
export EDITOR='vim'
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

HISTSIZE=15000 # Größe der History
SAVEHIST=10000 # Maximale Anzahl der Einträge, die gespeichert werden
HISTFILE=$HOME/.zsh_history # Speicherort der History
WORDCHARS='*?_-[]~&;!#$%^(){}<>'
is_root_shell && HISTFILE=$HOME/.zsh_history.root
setopt interactivecomments
# Bei verbesserungen folgende Nachfrage:
# %R -> aktueller Befehl,
# %r -> Verbesserungsvorschlag
  SPROMPT='zsh: correct '%R' to '%r' ? ([Y]es/[N]o/[E]dit/[A]bort) '

# Farben, die 'ls' nutzen soll, werden auch in Completions genutzt (s.u.)
#  export LS_COLORS='no=0:fi=0:di=32:ln=36:or=1;40:mi=1;40:pi=31:so=33:b'\
#'d=44;37:cd=44;37:ex=35:*.jpg=1;32:*.jpeg=1;32:*.JPG=1;32:*.gif=1;32:*.'\
#'.png=1;32:*.jpeg=1;32:*.ppm=1;32:*.pgm=1;32:*.pbm=1;32:*.c=1;33:*.C=1;'\
#'33:*.h=1;33:*.cc=1;33:*.awk=1;33:*.pl=1;33:*.bz2=1;35:*.gz=1;31:*.tar='\
#'1;31:*.zip=1;31:*.lha=1;31:*.lzh=1;31:*.arj=1;31:*.tgz=1;31:*.taz=1;31'\
#':*.html=1;34:*.htm=1;34:*.doc=1;34:*.txt=1;34:*.o=1;36:*.a=1;36:*.php3=1;31'
  eval `dircolors`

# functions {{{
######################################################################
# Funktionen
######################################################################
  loading functions

  # watch in farbe ;)
  botch() {
    while true; do
      (echo -en '\033[H';
        CMD="$@";
        zsh -c "$CMD" | while read LINE; do
          echo -n "$LINE";
          echo -e '\033[0K' ;
        done;
        echo -en '\033[J') | tac | tac ;
      sleep 2 ;
    done;
  }

  # archive entpacken
  extract() {
    if [[ -z "$1" ]]; then
      print -P "usage: \e[1;36mextract\e[1;0m < filename >"
      print -P "       Extract the file specified based on the extension"
    elif [[ -f $1 ]]; then
      case ${(L)1} in
          *.tar.bz2)  tar -jxvf $1;;
          *.tar.gz)   tar -zxvf $1;;
          *.bz2)      bunzip2 $1   ;;
          *.gz)       gunzip $1   ;;
          *.jar)      unzip $1       ;;
          *.rar)      unrar x $1   ;;
          *.tar)      tar -xvf $1   ;;
          *.tbz2)     tar -jxvf $1;;
          *.tgz)      tar -zxvf $1;;
          *.zip)      unzip $1      ;;
          *.Z)        uncompress $1;;
         *)          echo "Unable to extract '$1' :: Unknown extension"
      esac
    else
      echo "File ('$1') does not exist!"
    fi
  }

  # archive packen
  smartcompress() {
    if [ $2 ]; then
      case $2 in
              tgz | tar.gz)   tar -zcvf$1.$2 $1 ;;
              tbz2 | tar.bz2) tar -jcvf$1.$2 $1 ;;
              tar.Z)          tar -Zcvf$1.$2 $1 ;;
              tar)            tar -cvf$1.$2  $1 ;;
              gz | gzip)      gzip           $1 ;;
              bz2 | bzip2)    bzip2          $1 ;;
              *)
              echo "Error: $2 is not a valid compression type"
              ;;
      esac
    else
      smartcompress $1 tar.gz
    fi
  }
  # screenshot knipsen
  sshot() {
    [[ ! -d ~/shots  ]] && mkdir ~/shots
    #cd ~/shots ; sleep 5 ; import -window root -depth 8 -quality 80 `date "+%Y-%m-%d--%H:%M:%S"`.png
    #cd ~/shots ; sleep 5; import -window root shot_`date --iso-8601=m`.jpg
    if [ $# = 0 ] ; then
      echo "     Usage        : $0 pattern"
      echo "     Example      : $0 fnord 85"
    else
      sleep 5; import -window root -quality $2 ~/shots/Screenshot-$1-`date +%y%m%d`.jpg;
    fi
  }

# Übersetzung bei dict.leo.org
  leo() { $BROWSER "http://dict.leo.org/?search=$*" }

# "m"ake directory and "cd" to it
  mcd() { nocorrect mkdir -p "$@"; cd "$@" }  # mkdir && cd

# List all executables which contain $1
  lsexe() { ls -l --color=auto $^path/*$1*(*N) }

# Find all files with suid set in $PATH
  suidfind() { ls -l --color=auto $^path/*(.sN) }

  mac_to_ipv6 () {
    mac=("${(s/:/)1}")
    printf "fe80::%02x%02x:%02x:%02x:%02x\n" $(( 0x$mac[1] ^ 0x02 )) 0x$mac[2] 0x$mac[3]ff 0xfe$mac[4] 0x$mac[5]$mac[6]
  }
# }}}

  ## format of process time reports with 'time'
  TIMEFMT='Real: %E User: %U System: %S Percent: %P Cmd: %J'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'
  alias pwgen='pwgen  -B -n 13'
  alias sshnk='ssh -o UserKnownHostsFile=/dev/null'
  alias apt='sudo apt'
  alias pacman='sudo pacman'
  alias apt-get='sudo apt-get'
  alias tcpdump='sudo tcpdump'

  alias gvim='gvim -p'

  alias diff='diff -x .svn'
  if [[ -e ~/.alias ]]; then
    . ~/.alias
  fi
  alias ls='ls --color=auto' # Farbe. Wichtig! Benutzt $LS_COLORS
  alias l='ls -alF'
  if [[ -e ~/.zshrc.sec_host ]]; then
    source ~/.zshrc.sec_host
  fi
  if [[ -d ~/go ]]; then
    #export GOROOT=~/go/go-1.11.2
    export GOPATH=~/go/packages
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
  fi

# Quote pasted URLs

autoload url-quote-magic

zle -N self-insert url-quote-magic

# File sort for completion
zstyle ':completion:*:*:*:*:*' file-sort date

if is_root_shell ; then
  #echo "No completer...";
else
  # The next line updates PATH for the Google Cloud SDK.
  if [ -e /home/matthias/google-cloud-sdk/path.zsh.inc ]; then
    source '/home/matthias/google-cloud-sdk/path.zsh.inc'
  fi
  # The next line enables bash completion for gcloud.
  if [ -e /home/matthias/google-cloud-sdk/completion.zsh.inc ]; then
    source '/home/matthias/google-cloud-sdk/completion.zsh.inc'
  fi

  which aws_zsh_completer.sh >/dev/null && source aws_zsh_completer.sh
fi

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

KDE_SESSION_ID=$KDE_SESSION_ID
export KDE_SESSION_ID
#source <(kubectl completion zsh)
#source <(zkubectl completion zsh)
if [[ -e ~/.ng_completion ]]; then
  source ~/.ng_completion
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

PATH="/home/mkerk/perl5/bin${PATH:+:${PATH}}"; export PATH;
LGOPATH="/home/mkerk/lgo" ; export LGOPATH
PERL5LIB="/home/mkerk/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/mkerk/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/mkerk/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/mkerk/perl5"; export PERL_MM_OPT;


unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
