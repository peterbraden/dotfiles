export GIT="$(which git)"

############ Prompt ######################

autoload colors && colors

bindkey -e

git_branch() {
  echo $($GIT symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($GIT status --porcelain 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
      echo "%{$fg[green]%}$(git_prompt_info)%{$reset_color%}"
  else
    if [[ $st =~ ^nothing ]]
    then
      echo "%{$fg[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "%{$fg[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($GIT symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}


directory_name(){
  echo "%{$fg[green]%}%~%{${reset_color%}%}"
}




function precmd() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac

export PROMPT="$(directory_name):$(git_dirty)$ "

}

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

################### History #############
HISTFILE=$HOME/.history/$(date -u +%Y-%m-%d)._sh
HISTSIZE=2000
SAVEHIST=2000
setopt   appendhistory
setopt   incappendhistory
setopt histignorealldups
setopt EXTENDED_HISTORY
setopt share_history

source $HOME/.profile

autoload -Uz compinit
compinit

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

eval "`npm completion`"
