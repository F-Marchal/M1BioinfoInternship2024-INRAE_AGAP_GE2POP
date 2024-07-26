if true; then
    if [ -x /usr/bin/dircolors ]; then
         test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
         alias ls='ls --color=auto'
         #alias dir='dir --color=auto'
         #alias vdir='vdir --color=auto'

         alias grep='grep --color=auto'
         alias fgrep='fgrep --color=auto'
         alias egrep='egrep --color=auto'
    fi

    # colored GCC warnings and errors
    #export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

    # some more ls aliases
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

    # Alias definitions.
    # You may want to put all your additions into a separate file like
    # ~/.bash_aliases, instead of adding them here directly.
    # See /usr/share/doc/bash-doc/examples in the bash-doc package.

fi


#
reload_bashrc() {
    source ~/.bashrc
}

#
edit_bashrc() {
    nano $@  ~/.bashrc
    reload_bashrc

}

edit_alias() {
    nano $@  ~/.bash_aliases
    reload_bashrc
}


list_env() {
    conda env list
}

list_modules() {
    module avail
}

exit_env() {
    conda deactivate
    source .bashrc
}

gecko_env() {
    conda activate GeCKO_env
}

#
switch() {
    path=$(pwd)
    if [[ "$(hostname)" == *"login"* ]]; then
        if [ "$1" == "long" ]; then
             srun --partition "agap_long" --job-name "marchalf's nodes" --pty bash $@
        else 
            if [ "$1" == "mem" ]; then
                  srun --partition "agap_bigmem" --job-name "marchalf's nodes" --pty bash $@
            else
                  srun --partition "agap_normal" --job-name "marchalf's nodes" --pty bash $@
            fi
        fi
    else
        exit 0
    fi
    cd "$path"
}




# Définition de la fonction add_bashrc
add_sbatch() {
    local file="$1"
    if [[ "$file" != *".sbatch" ]]; then
        file="${file}.sbatch"
    fi
    echo "$file"
}

# Définition de la fonction sb_touch
sb_touch() {
    local file=$(add_sbatch "$1")
    if [ -e "$file" ]; then
        echo "$file exist"
        return 1
    fi

    echo "#!/bin/bash" > $file
    echo "#SBATCH --job-name=$(basename $file .sbatch)" >> $file
    echo "#SBATCH --output=./log_%j_%x_out.txt" >> $file
    echo "#SBATCH --error=./log_%j_%x_err.txt" >> $file
    echo "#SBATCH --partition=agap_normal" >> $file
    echo "#SBATCH --time=0:01:00" >> $file
    echo "#SBATCH --nodes=1" >> $file
    echo "#SBATCH --ntasks-per-node=1" >> $file
    echo "echo [\$(date +'%d-%m-%Y')]-[\$(date +'%H:%M:%S')]-[\$SLURM_JOB_ID]-[Start] \$0 \$@" >> $file
    echo "# --------------------------------------------------------------------------------- #" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "" >> $file
    echo "# --------------------------------------------------------------------------------- #" >> $file
    echo "echo [\$(date +'%d-%m-%Y')]-[\$(date +'%H:%M:%S')]-[\$SLURM_JOB_ID]-[Start] \$0 \$@" >> $file

    return 0
}

# Définition de la fonction sb_nano
sb_soft_nano() {
    local file=$(add_sbatch "$1")
    sb_touch "$file"
    nano "$file"
}

sb_nano() {
    if [[ -z "$1" ]]; then
        echo "Missing file name"
        return 1
    fi
    local file=$(add_sbatch "$1")

    sb_touch "$file"
    nano "$file"

    echo "Insert commit message :"

    read message
    if [ -z "$message" ]; then
        return 0
    fi

    git add $file
    git_message=$(git commit -m "$message")
    echo "$git_message"

}

my_queue() {
    squeue --user=$(whoami)

}

run() {

    file=$1
    shift

    if [[ $file == *.sbatch ]]; then
        message=$(sbatch $file) $@

    else
        message=$(bash $file) $@

    fi

    echo $message
}

cd_gecko() {
    cd /home/marchalf/scratch/Johanna/GeCKO/READ_MAPPING/EXAMPLE/PAIRED_END

}

cd_trans() {
    cd /home/marchalf/projects/GE2POP/2024_TRANS_CWR

}

cd_projet() {
    cd ~/projects/

}

scancel_all() {
    scancel --user=$(whoami)
}

load_samtools() {
     module load samtools/1.14-bin
}

load_python3_9_13() {
     module load python/3.9.13
}

load_seqkit() {
    module load seqkit/2.8.1

}

load_star() {
    module load star/2.7.3a

}
