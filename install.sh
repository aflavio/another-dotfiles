#!/bin/bash

set -e
# setting colors
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
GRAY="$(tput setaf 7)"
BLUE="$(tput setaf 4)"
BOLD="$(tput bold)"
NORMAL="$(tput sgr0)"

checkDirectories() {
    local_dirs=("$@")

    for (( i = 0 ; i < ${#local_dirs[@]} ; i++ ))
        do
            if [ ! -d "$i" ]; then
                mkdir ${local_dirs[$i]}
            fi
    done
}

main() {
    # vars
    DOTFILES=$HOME/.dotfiles

    # create directories
    directories=(".dotfiles")

    # checking directories
    echo "${BOLD}Checking Directories..."
    checkDirectories "${directories[@]}" 

    # clonnig repositories
    echo "${BOLD}Clonning Respository..."
    printf "${NORMAL}${GRAY}"

    git clone https://github.com/aflavio/another-dotfiles.git .dotfiles

    cd .dotfiles
    git submodule update --init --recursive
    cd ..
    echo "done."

    # creating symlinks
    printf ""
    echo -e "${BOLD}Creating symlinks..."

    ln -s $DOTFILES/vim ~/.vim
    linkables=$( find -H "$DOTFILES" -name '*.symlink' )

    for file in $linkables ; do
        target="$HOME/.$( basename $file ".symlink" )"
        ln -s $file $target
    done

    # linking font files
    ls -s $DOTFILES/fonts .fonts
    source $HOME/.zshrc

    echo 'done.'
    printf "${NORMAL}"

    # installing vim plugins
    printf "${BOLD}"
    echo -e '\nNow, all Vim Plugins will be installed. This can will take a while...'
    echo 'If it`s fail, please run manually the follow command on shell:'
    printf "${RED}vim +PlugInstall${NORMAL}${BOLD}"
    echo -e '\nPress any key to continue'
    #read flag
    vim +PlugInstall +qall
    echo 'done.'
    printf "${NORMAL}"

    # copyng init.d script files
    ln -s $DOTFILES/scripts/init.d/reset-ethernet.sh /etc/init.d/reset-ethernet.sh

}

splash() {
    printf "${BLUE}"
    echo '██      ▄   ████▄    ▄▄▄▄▀ ▄  █ ▄███▄   █▄▄▄▄          '
    echo '█ █      █  █   █ ▀▀▀ █   █   █ █▀   ▀  █  ▄▀          '
    echo '█▄▄█ ██   █ █   █     █   ██▀▀█ ██▄▄    █▀▀▌           '
    echo '█  █ █ █  █ ▀████    █    █   █ █▄   ▄▀ █  █           '
    echo '   █ █  █ █         ▀        █  ▀███▀     █            '
    echo '  █  █   ██                 ▀            ▀             '
    echo ' ▀                                                     '
    echo '██▄   ████▄    ▄▄▄▄▀ ▄████  ▄█ █     ▄███▄     ▄▄▄▄▄   '
    echo '█  █  █   █ ▀▀▀ █    █▀   ▀ ██ █     █▀   ▀   █     ▀▄ '
    echo '█   █ █   █     █    █▀▀    ██ █     ██▄▄   ▄  ▀▀▀▀▄   '
    echo '█  █  ▀████    █     █      ▐█ ███▄  █▄   ▄▀ ▀▄▄▄▄▀    '
    echo '███▀          ▀       █      ▐     ▀ ▀███▀             '
    echo '                       ▀                               '
    echo -e 'Installing...\n'
    printf "${NORMAL}"

  #env zsh
}

bye() {
    printf "${BLUE}"
    echo -e '\n\n'
    echo 'Thanks for installing Another Dotfiles'
    echo 'Suggestions: aflavio at gmail.com'
}




splash
main
bye
