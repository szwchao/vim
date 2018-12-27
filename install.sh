#!/bin/bash

# 获取平台类型，mac还是linux平台
function get_platform_type()
{
    echo $(uname)
}

function clone_repo()
{
    rm -rf ~/.vim_bak
    mv ~/.vim ~/.vim_bak
    git clone https://github.com/szwchao/vim ~/.vim
    cd ~/.vim
    git fetch origin test:test
    git checkout test
}

# 获取linux平台类型，ubuntu还是centos
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

# 安装mac平台必要软件
function install_prepare_software_on_mac()
{
    brew install vim gcc cmake ctags-exuberant curl ack
}

# 安装ubuntu发行版必要软件
function install_prepare_software_on_ubuntu()
{
    sudo apt-get install -y ctags build-essential cmake python-dev python3-dev fontconfig curl libfile-next-perl ack-grep
    sudo apt-get install -y vim vim-gtk
}

# 拷贝文件
function copy_files()
{
    rm -rf ~/.vimrc
    ln -s ~/.vim/.vimrc ~/.vim

    rm -rf ~/.vimrc.local
    ln -s ~/.vim/.vimrc.plugins ~/.vim
}

# 安装mac平台字体
function install_fonts_on_mac()
{
    rm -rf ~/Library/Fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf
    cp ./fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf ~/Library/Fonts
}

# 安装linux平台字体
function install_fonts_on_linux()
{
    mkdir ~/.fonts
    curl -fLo ~/.fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete\ Mono.ttf --create-dirs https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf

    fc-cache -vf ~/.fonts
}

# 下载插件管理软件vim-plug
function download_vim_plug()
{
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

# 安装vim插件
function install_vim_plugin()
{
    vim -c "PlugInstall" -c "q" -c "q"
}

# 打印logo
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

# 在mac平台安装vimplus
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

# 在ubuntu发行版安装vimplus
function install_vimplus_on_ubuntu()
{
    install_prepare_software_on_ubuntu
    download_font
    begin_install_vimplus
}

# 在linux平台安装vimplus
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

# main函数
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

# 调用main函数
main
