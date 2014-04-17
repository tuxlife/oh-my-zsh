# persönliche Vorlage
# mix aus aussiegeek.zsh-theme af-magic.zsh-theme
is_root_shell() { [[ $USER == root ]] }
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if [[ -n "$SSH_CLIENT" ]]; then
  _PROMPT="%n@%m "
else
  _PROMPT=''
fi
#if [[ $LIVESYSTEM == 1 ]]; then
#  _PROMPT="%{$bg[red]$fg[white]%}$_PROMPT%{$reset_color%}"
#fi
[[ -z $SCHROOT_SESSION_ID ]] || _PROMPT="[${SCHROOT_SESSION_ID%%-*}] => ${_PROMPT}"

_PROMPT="%B${_PROMPT}[%D{%Y%m%d %H%M%S}%{$reset_color%}] %~ "
#  PROMPT="%B${PROMPT}[%b%{$bg[$DATEBACK]$fg[$DATEFRONT]%}%D{%m-%d %T}%{$reset_color%}%B] %~ %1(j.(%B%j%b%).)%#%b "
is_root_shell && PROMPT="%{$fg[red]%}$_PROMPT%{$fg[red]%}"
  #RPROMPT='%(?..:( (%?%))'
  #RPROMPT="%(?..%{$bg[red]$fg_bold[white]%}:( (%?%)%{$reset_color%} )%~"
RPROMPT="%(?..%{$bg[red]$fg_bold[white]%}:( (%?%)%{$reset_color%} )"

PROMPT2="%_> "


# primary prompt
PROMPT='$FG[237]------------------------------------------------------------%{$reset_color%}
${_PROMPT}\
$FG[032]$(git_prompt_info)\
$FG[105]%(!.#.»)%{$reset_color%} '
#PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
#RPS1='${return_code}'


# color vars
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

## right prompt
#if type "virtualenv_prompt_info" > /dev/null
#then
#	RPROMPT='$(virtualenv_prompt_info)$my_gray%n@%m%{$reset_color%}%'
#else
#	RPROMPT='$my_gray%n@%m%{$reset_color%}%'
#fi

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$my_orange("
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔%{$rest_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$my_orange)%{$reset_color%}"

# Editieren und Neuladen der .zshrc
  alias  __='$EDITOR ~/.zshrc'
  alias ___='source  ~/.zshrc'
