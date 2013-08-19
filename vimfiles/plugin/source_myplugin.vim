" 防止重新载入脚本{{{2
if exists('g:source_myplugin')
   finish
endif
let g:source_myplugin = 1
"}}}

" 全局变量 {{{2
" 自己插件所在目录
if g:platform == 'win'
   let g:myplugin_dir = $VIM.'/vimfiles/myplugin/'
elseif g:platform == 'linux'
   let g:myplugin_dir = '~/.vim/myplugin/'
endif
"}}}

"----------------------------------------------------------------------------
"@函数说明：   列出指定目录下的所有文件 {{{2
"@参    数：   dir（指定目录）
"@参    数：   ...（扩展名，留空为所有文件）
"@返 回 值：   文件名列表
"----------------------------------------------------------------------------
fun! GetAllFilesInDir(dir, ...)
  if !isdirectory(a:dir)
     return
  endif
  let files = filter(split(globpath(a:dir, "*"), '\n'), '!isdirectory(v:val)')
  if a:0 == 1
     let result = []
     for filename in files
        let fileExtension = matchstr(substitute(filename,'^.*\\','','g'),'\.[^.]\{-}$')
        if fileExtension == '.'.a:1
           call add(result, filename)
        endif
     endfor
     return result
  else
     return files
  endif
endfun
"}}}

"----------------------------------------------------------------------------
"@函数说明：   加载自己写的脚本 {{{2
"----------------------------------------------------------------------------
fun! SourceMyPlugin()
   let l:dir = g:myplugin_dir
   let l:result = GetAllFilesInDir(l:dir, 'vim')
   for plugin in l:result
      exe ':source '.plugin
   endfor
endfun
"}}}

call SourceMyPlugin()

" vim:fdm=marker:fmr={{{,}}}
