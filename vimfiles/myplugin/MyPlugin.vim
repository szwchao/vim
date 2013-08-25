" �Զ��庯��{{{1

" ��ֹ��������ű�{{{2
"------------------------------------------------------------------------------"
if exists('g:loaded_myplugin')
    finish
endif
let g:loaded_myplugin = 1
"------------------------------------------------------------------------------"
"}}}

" ƽ̨�ж�{{{2
"------------------------------------------------------------------------------"
if (has("win32") || has("win95") || has("win64") || has("win16"))
    let g:platform = 'win'
else
    let g:platform = 'linux'
endif
"------------------------------------------------------------------------------"
"}}}

" ���롢���С����� {{{2
"------------------------------------------------------------------------------"
"����CompileRun�������������ý��б��������
func! CompileRun()
    if exists('g:current_project')
        if !empty(g:current_project)
            echo "��ʼ���빤��"
            call F3make(1)
            return
        endif
    endif
    if (&filetype != 'c') && (&filetype != 'cpp') && (&filetype != 'python')
        echo 'ֻ�ܱ���c,cpp,python�ļ�!'
        return
    endif
    exec "w"
    if &filetype == 'c'
        if g:platform == 'win'
            set makeprg=gcc\ -o\ %<.exe\ %
            exec "silent make"
            set makeprg=make
            exec "!%<.exe"
        elseif g:platform == 'linux'
            set makeprg=gcc\ -o\ %<\ %
            exec "silent make"
            set makeprg=make
            exec "!./%<"
        endif
    elseif &filetype == 'cpp'
        if g:platform == 'win'
            set makeprg=g++\ -o\ %<.exe\ %
            exec "silent make"
            set makeprg=make
            exec "!%<.exe"
        elseif g:platform == 'linux'
            set makeprg=g++\ -o\ %<\ %
            set makeprg=make
            exec "silent make"
            exec "!./%<"
        endif
    elseif &filetype == 'python'
        if g:platform == 'win'
            if exists('g:python_dir')
                exec "!".g:python_dir." %"
            elseif
                echo "plz set g:python_dir first in your vimrc file"
            endif
        elseif g:platform == 'linux'
            exec "!python %<"
        endif
    endif
    exe ":cw"
endfunc
"��������CompileRun

"����Debug�������������Գ���
func! Debug()
    if exists('g:current_project')
        if !empty(g:current_project)
            echo "��ʼ���빤��"
            call F3make(0)
            return
        endif
    endif
    exec "w"
    "C����
    if &filetype == 'c'
        exec "!gcc % -g -o %<.exe"
        exec "!gdb %<.exe"
        "C++����
    elseif &filetype == 'cpp'
        exec "!g++ % -g -o %<.exe"
        exec "!gdb %<.exe"
        "Java����
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!jdb %<"
    endif
endfunc
"��������Debug
"------------------------------------------------------------------------------"
"}}}

" ��ȡ��ǰ����µĺ�����{{{2
"------------------------------------------------------------------------------"
function! GetFunctionName()
    " search backwards for our magic regex that works most of the time
    let flags = "bn"
    let fNum = search('^\w\+\s\+\w\+.*\n*\s*[(){:].*[,)]*\s*$', flags)
    " if we're in a python file, search backwards for the most recent def: or
    " class: declaration
    if match(expand("%:t"), ".py") != -1
        let dNum = search('^\s\+def\s*.*:\s*$', flags)
        let cNum = search('^\s*class\s.*:\s*$', flags)
        if dNum > cNum
            let fNum = dNum
        else
            let fNum = cNum
        endif
    endif

    "paste the matching line into a variable to display
    let tempstring = getline(fNum)

    "return the line that we found to be the function name
    return tempstring
endfun
"------------------------------------------------------------------------------"
"}}}

" ��������{{{2
"------------------------------------------------------------------------------"
func! ToggleColorScheme(...)
    if a:0 == 0
        "ȡ��������ɫ
        let dir = $VIM . '/vimfiles/colors/'
        let colors = GetAllFilesInDir(dir, 'vim')
        "ȥ��·������չ��
        for i in range(len(colors))
            let colors[i] = fnamemodify(colors[i], ':t:r')
        endfor
        "��g:colors_name�õ���ǰ��ɫ������
        let i = index(colors, g:colors_name)
        "ȡ��һ����ɫ����
        let i = (i+1) % len(colors)
        "������ɫ����
        exe 'colorscheme ' . get(colors, i)
        call SetMyStatusLine()
    elseif a:0 == 1
        let color = a:1
        "������ɫ����
        exe 'colorscheme ' . color
        " ���¸���״̬��
        call SetMyStatusLine()
    endif

    "Notice:���Ҫ����ǰ��ɫ��echo g:colors_name

    " ���¸���visualmark.vim��ǩ
    if &bg == "dark"
        highlight SignColor ctermfg=white ctermbg=blue guifg=white guibg=#2f4f4f
    else
        highlight SignColor ctermbg=white ctermfg=blue guibg=DarkOrange1 guifg=black
    endif

    " ���¸���ƥ������
    if exists('g:loaded_rain_bow')
        cal rainbow#clear()
        cal rainbow#activate()
    endif
endfunc
command! -nargs=0 ToggleColorScheme :call ToggleColorScheme() | silent! echo g:colors_name

fun! AutoChangeColorScheme()
    if &filetype == 'txt'
        call ToggleColorScheme('colorful')
    else
        call ToggleColorScheme('bluechia')
    endif
endfun
"------------------------------------------------------------------------------"
"}}}

" �����к�/����к� {{{2
"------------------------------------------------------------------------------"
function! ToggleNuMode()
    if version >= 703
        if(&rnu == 1)
            set nu
        else
            set rnu
        endif
    end
endfunc 
command! -nargs=0 ToggleNuMode :call ToggleNuMode()
"------------------------------------------------------------------------------"
"}}}

" �ѵ�ǰ�ļ���浽���� {{{2
"------------------------------------------------------------------------------"
function! SaveCurrentFileToDesktop()
    "let filename = fnamemodify(getcwd(), "%:t")
    let filename = expand("%")
    let save_name = $HOME .'\Desktop\'. filename
    if filereadable(save_name)
        let l:inputkey = input("File Exist! Overwrite? (Y/N) ")
        if l:inputkey == 'y' || l:inputkey == 'Y' || l:inputkey ==# "" 
            exe ":w! ". save_name
        endif
    else
        exe ":w ". save_name
    endif
endfunc 
command! -nargs=0 SaveCurrentFileToDesktop :call SaveCurrentFileToDesktop()
"------------------------------------------------------------------------------"
"}}}

" �л���ȫ���� {{{2
"------------------------------------------------------------------------------"
fun! ToggleOmnifunc()
    if &omnifunc == ''
        return
    elseif &omnifunc == 'ccomplete#Complete'
        set omnifunc=omni#cpp#complete#Main
    elseif &omnifunc == 'omni#cpp#complete#Main'
        set omnifunc=ccomplete#Complete
    endif
endfun
"------------------------------------------------------------------------------"
"}}}

" ��������ʱ�� {{{2
"------------------------------------------------------------------------------"
fun! InsertDateTime()
    silent! execute "normal a".strftime("%c")."\<ESC>"
endfun
"------------------------------------------------------------------------------"
"}}}

" ��ʾrgb.txt��������ɫ {{{2
"------------------------------------------------------------------------------"
fun! DisplayAllColors()
   let bname = '_All_Colors_'
   " If the window is already open, jump to it
   let winnum = bufwinnr(bname)
   if winnum != -1
      if winnr() != winnum
         " If not already in the window, jump to it
         exe winnum . 'wincmd w'
      endif
      setlocal modifiable
      " Delete the contents of the buffer to the black-hole register
      silent! %delete _
   else
      let bufnum = bufnr(bname)
      if bufnum == -1
         let wcmd = bname
      else
         let wcmd = '+buffer' . bufnum
      endif
      exe 'silent! topleft ' . '15' . 'split ' . wcmd
   endif
   " Mark the buffer as scratch
   setlocal buftype=nofile
   "setlocal bufhidden=delete
   setlocal noswapfile
   setlocal nowrap
   setlocal nobuflisted
   setlocal winfixheight
   setlocal modifiable

   " Setup the cpoptions properly for the maps to work
   let old_cpoptions = &cpoptions
   set cpoptions&vim
   " Create a mapping
   " Restore the previous cpoptions settings
   let &cpoptions = old_cpoptions
   " Display the result
   silent! %delete _

   let fname = $VIMRUNTIME . '\rgb.txt'
   let rgb_pattern = '^\s*\zs\(\d\+\s*\)\{3}\ze\w*$'
   let color_pattern = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
   let result = []
   for line in readfile(fname)
       " ƥ�䵽����ɫrgb��ֵ
       let match_rgb = matchstr(line, rgb_pattern)
       " ƥ�䵽����ɫ�ַ���
       let match_color_str = matchstr(line, color_pattern)
       " ȥ�����а���grey����
       let grey_str = matchstr(line, '^\s*\(\d\+\s*\)\{3}\zs.*grey.*$')
       if len(grey_str) > 1
           continue
       endif
       if match_rgb
           let _match_color_str_ = '_' . match_color_str . '_'
           if &background == 'light'
               exec 'hi col_'.match_color_str.' guifg='.match_color_str
               exec 'hi col_'._match_color_str_.' guibg='.match_color_str.' guifg=black'
           else
               exec 'hi col_'.match_color_str.' guifg='.match_color_str
               exec 'hi col_'._match_color_str_.' guibg='.match_color_str.' guifg=black'
           endif
           exec 'syn keyword col_'.match_color_str.' '.match_color_str
           exec 'syn keyword col_'._match_color_str_.' '._match_color_str_
           let rgb_words = split(match_rgb, '\s\+')
           let r = rgb_words[0]
           let g = rgb_words[1]
           let b = rgb_words[2]
           let r_hex = printf("%02X", r)
           let g_hex = printf("%02X", g)
           let b_hex = printf("%02X", b)
           let rgb_hex = '#'.r_hex.g_hex.b_hex
           " ����ø�����һ��
           let str1 = match_rgb . rgb_hex . '    ' . match_color_str
           let len1 = len(str1)
           let str2 = _match_color_str_
           let len2 = len(str2)
           let space_len = 70 - len1 - len2
           let i = 1
           let space = " "
           while i < space_len
               let space = space . " "
               let i = i + 1
           endw
           let output = str1 . space . str2
           call add(result, output)
       endif
   endfor
   silent! 0put =result

   " Delete the last blank line
   silent! $delete _
   " Move the cursor to the beginning of the file
   normal! gg
   setlocal nomodifiable
endfun
command! -nargs=* DisplayAllColors call DisplayAllColors()
"------------------------------------------------------------------------------"
"}}}

" �Զ��޸�Modified�����ʱ�� {{{2
"------------------------------------------------------------------------------"
function! LastModified()
  if &modified
    let save_cursor = getpos(".")
    let n = min([20, line("$")])
    keepjumps exe '1,' . n . 's#^\(.\{,50}Modified: \).*#\1' .
          \ strftime('%c') . '#e'
    call histdel('search', -1)
    call setpos('.', save_cursor)
  endif
endfun

" vim:fdm=marker:fmr={{{,}}} foldlevel=1:
"}}}
