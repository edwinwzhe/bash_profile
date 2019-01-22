#!/bin/sh

install() {

    src=$1
    target=$2

    if [[ -f $src ]]
    then
        if [[ `grep "source $target" $src | wc -l` -ne 0 ]]
        then
            echo "${target} already installed, skipped."
            return 1
        fi

        timestamp=`date '+%Y%m%d.%H%M%S'`
        backup="${src}.backup.$timestamp"

        cp $src $backup
        echo "$src backed up as $backup"

        if [[ ! -f $backup ]]
        then
            echo "Failed to backup $src, aborted."
            return 1
        fi

        echo "source $target" > $src
        echo "" >> $src
        cat $backup >> $src
    else
        touch $src
        echo "source $target" > $src
    fi

    return 0
}

### MAIN ###
echo "Installing profiles..."

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )" 

##############################################3
echo "Installing vim profile..."
install $HOME/.vimrc $CURRENT_DIR/vimrc

if [[ `vi --version | grep 'Small version' | wc -l` -eq 1 ]]
then
    echo "\-\> Installing vim Huge version..."
    if [[ -f /usr/bin/apt-get ]]
    then
        sudo apt-get install vim-gui-common
        sudo apt-get install vim-runtime
    else
        echo "   Not sure how to install..."
    fi
fi

if [[ ! -d $HOME/.vim/bundle/Vundle.vim ]]
then
    echo "\-\> Installing vim plugin: vundle..."
    mkdir -p $HOME/.vim/bundle/Vundle.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

if [[ $? -eq 0 ]]
then
    echo "Install vim color theme..."
    mkdir -p ~/.vim/colors
    cd ~/.vim/colors                                            
    wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400  
    cd -
fi

##############################################3
echo "Installing bash profile..."
install $HOME/.bash_profile $CURRENT_DIR/bash_profile

echo "All Done!"
