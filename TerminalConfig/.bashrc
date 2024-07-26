# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi


# Prompt 
colorprompt="yes"
if [ -n "$colorprompt" ]; then
    # Vérification du nom d'hôte pour la couleur de \w
    GREEN="\[\033[0;32m\]" 
    RED="\[\033[0;31m\]"
    ORANGE="\[\033[0;33m\]"
    BLUE_LIGHT="\[\033[0;34m\]"
    PURPLE="\[\033[0;35m\]"
    RESET="\[\033[0m\]"

    colorprompt="yes"

    if [[ "$(hostname)" != *"login"* ]]; then
        HOST_COLOR="${PURPLE}"
    else
        HOST_COLOR="${ORANGE}"
    fi

    # Configuration de l'invite de commande avec les couleurs
    export PROMPT_COMMAND='export PS1="(${CONDA_DEFAULT_ENV}) ${GREEN}[\t]-\u${RED}@${HOST_COLOR}\h${RED}:${BLUE_LIGHT}\w${RED}\n\$${RESET} "'
    export PS1="${GREEN}[\t]-\u${RED}@${HOST_COLOR}\h${RED}:${BLUE_LIGHT}\w${RED}\n\$${RESET} "

else
    # Configuration de l'invite de commande sans les couleurs
    export PS1="[\t]-\u@\h:\p\n\$ "
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pitollatb/work_agap_id-bin/img/anaconda/3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pitollatb/work_agap_id-bin/img/anaconda/3/etc/profile.d/conda.sh" ]; then
        . "/home/pitollatb/work_agap_id-bin/img/anaconda/3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pitollatb/work_agap_id-bin/img/anaconda/3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

