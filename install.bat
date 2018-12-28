@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

@set APP_PATH=%HOME%\.vim
IF NOT EXIST "%APP_PATH%" (
    call git clone https://github.com/szwchao/vim "%APP_PATH%"
) ELSE (
    @set ORIGINAL_DIR=%CD%
    echo updating vim
    chdir /d "%APP_PATH%"
    call git pull
    chdir /d "%ORIGINAL_DIR%"
    call cd "%APP_PATH%"
)

IF NOT EXIST "%APP_PATH%/gvim_exe" (
    call curl -fLo %APP_PATH%/gvim_exe/gvim81.exe --create-dirs "https://ftp.nluug.nl/pub/vim/pc/gvim81.exe"
    chdir /d "%APP_PATH%"/gvim_exe
    call gvim81.exe
)

call mklink "%HOME%\.vimrc" "%APP_PATH%\.vimrc"
call mklink "%HOME%\_vimrc" "%APP_PATH%\.vimrc"
call mklink /J "%HOME%\.vim" "%APP_PATH%\.vim"

IF NOT EXIST "%APP_PATH%/autoload" (
    call curl -fLo %APP_PATH%/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
)

IF NOT EXIST "%APP_PATH%/fonts" (
    call curl -fLo %APP_PATH%/fonts/SauceCodeProNerdFontCompleteMonoWindowsCompatible.ttf --create-dirs "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%%20Code%%20Pro%%20Nerd%%20Font%%20Complete%%20Mono%%20Windows%%20Compatible.ttf"
)

call vim -c "PlugInstall" -c "q" -c "q"
chdir /d "%ORIGINAL_DIR%"
