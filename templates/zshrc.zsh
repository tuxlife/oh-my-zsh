loading() { print -n ${(r:$COLUMNS-2-$#1:: :):-loading $1...}'\r' }
is_root_shell() { [[ $USER == root ]] }
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="random"
ZSH_THEME=""
ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"
ZSH_THEME="garyblessington"
ZSH_THEME="gnzh"
ZSH_THEME="aussiegeek"
ZSH_THEME="af-magic"
ZSH_THEME="mkerk"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

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
plugins=(git ssh-agent command-not-found encode64 fabric jira perl python screen svn )

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
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
is_root_shell && HISTFILE=$HOME/.zsh_history.root

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
# }}}

  ## format of process time reports with 'time'
  TIMEFMT="Real: %E User: %U System: %S Percent: %P Cmd: %J"
alias pwgen='pwgen  -B -n 13'

  alias gvim='gvim -p'

  alias diff='diff -x .svn'
  alias ilo='vim ~/SVN/sysop/acctmgmt/ilo.gpg'
  alias acct='vim ~/SVN/sysop/acctmgmt/accounts.gpg'
  alias pp='ssh puppet@puppet.zalando'
  if [[ -e ~/.alias ]]; then
    . ~/.alias
  fi
  alias ls='ls --color=auto' # Farbe. Wichtig! Benutzt $LS_COLORS
  alias l='ls -alF'
  if [[ -e ~/.zshrc.sec_host ]]; then
    source ~/.zshrc.sec_host
  fi

# Quote pasted URLs

autoload url-quote-magic

zle -N self-insert url-quote-magic
alias cmdb-client='~/GIT/zalando-cmdb-client/cmdb/client.py https://cmdb.zalando.net'
