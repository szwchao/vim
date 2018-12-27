#!/bin/bash

function get_platform_type()
{
    echo $(uname)
}

function clone_repo()
{
    rm -rf ~/.vim_bak
    mv ~/.vim ~/.vim_bak
    git clone --depth=1 https://github.com/szwchao/vim ~/.vim
    cd ~/.vim
    git fetch origin test:test
    git checkout test
}

function get_linux_platform_type()
{
    if which apt-get > /dev/null ; then
        echo "ubuntu" # debian ubuntu系列
    elif which yum > /dev/null ; then
        echo "centos" # centos redhat系列
    elif which pacman > /dev/null; then
        echo "archlinux" # archlinux系列
    else
        echo "invaild"
    fi
}

function install_prepare_software_on_mac()
{
    brew install vim gcc cmake ctags-exuberant curl ack
}

function install_prepare_software_on_ubuntu()
{
    sudo apt-get install -y ctags build-essential cmake python-dev python3-dev fontconfig curl libfile-next-perl ack-grep
    sudo apt-get install -y vim vim-gtk
}

function copy_files()
{
    rm -rf ~/.vimrc
    ln -s ~/.vim/.vimrc ~/.vimrc
}

function install_fonts_on_mac()
{
    rm -rf ~/Library/Fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf
    cp ./fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf ~/Library/Fonts
}

function install_fonts_on_linux()
{
    mkdir ~/.fonts
    curl -fLo ~/.fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Mono.ttf --create-dirs https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf

    fc-cache -vf ~/.fonts
}

function download_vim_plug()
{
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

function install_vim_plugin()
{
    vim -c "PlugInstall" -c "q" -c "q"
}

function print_logo()
{
    color="$(tput setaf 6)"
    normal="$(tput sgr0)"
    printf "${color}"
    echo '        __                __           '
    echo '__   __/_/___ ___  ____  / /_  _______ '
    echo '\ \ / / / __ `__ \/ __ \/ / / / / ___/ '
    echo ' \ V / / / / / / / /_/ / / /_/ (__  )  '
    echo '  \_/_/_/ /_/ /_/ ,___/_/\____/____/   '
    echo '               /_/                     ...is now installed!'
    echo ''
    echo ''
    echo 'Just enjoy it!'
    echo 'p.s. Follow me at https://github.com/chxuan.'
    echo ''
    printf "${normal}"
}

function install_vimplus_on_mac()
{
    clone_repo
    install_prepare_software_on_mac
    copy_files
    install_fonts_on_mac
    download_vim_plug
    install_vim_plugin
    print_logo
}

function begin_install_vimplus()
{
    clone_repo
    copy_files
    install_fonts_on_linux
    download_vim_plug
    install_vim_plugin
    print_logo
}

function install_vimplus_on_ubuntu()
{
    install_prepare_software_on_ubuntu
    begin_install_vimplus
}

function install_vimplus_on_linux()
{
    type=`get_linux_platform_type`
    echo "linux platform type: "${type}

    if [ ${type} == "ubuntu" ]; then
        install_vimplus_on_ubuntu
    else
        echo "not support this linux platform type: "${type}
    fi
}

function main()
{
    type=`get_platform_type`
    echo "platform type: "${type}

    if [ ${type} == "Darwin" ]; then 
        install_vimplus_on_mac
    elif [ ${type} == "Linux" ]; then
        install_vimplus_on_linux
    else
        echo "not support platform type: "${type}
    fi
}

main
