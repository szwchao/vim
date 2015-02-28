" 自定义函数{{{1

" 防止重新载入脚本{{{2
"------------------------------------------------------------------------------"
if exists('g:loaded_wiki2html')
    finish
endif
let g:loaded_wiki2html = 1
"------------------------------------------------------------------------------"
"}}}

if !has("python")
    echo "需要python支持"
    finish
endif
let s:scriptfolder = expand('<sfile>:p:h').'/wiki'

" wiki2html {{{2
"------------------------------------------------------------------------------"
function! Wiki2Html(...)
    if a:0 == 0
        let mode = "single"
    else
        let mode = "all"
    endif
    let current_file = expand("%:p")
    if current_file == ""
        echo "no markdown file"
        return
    endif
    let current_file_ext = expand("%:e")
    if current_file_ext != "md"
        echo "not markdown file"
        return
    endif
    let wiki_path = VimwikiGet('path')
    let html_path = VimwikiGet('path_html')
    let template_path = VimwikiGet('template_path')
    let template_file = VimwikiGet('template_default')
    let template_ext = VimwikiGet('template_ext')
    let template = template_path . template_file . template_ext
python << EOF
import sys, os, vim
sys.path.append(vim.eval('s:scriptfolder'))
from convert import MarkdownConverter
md_path = vim.eval("wiki_path")
html_path = vim.eval("html_path")
template = vim.eval("template")
mode = vim.eval("mode")
mc = MarkdownConverter(md_path, html_path, template)
if mode == "single":
    mc.convert_single_md_file_to_html(vim.eval("current_file"))
else:
    mc.convert_all_md_files_to_html()
EOF
    echo "done"
endfunc 
command! -nargs=0 Wiki2Html    :call Wiki2Html()
command! -nargs=0 WikiAll2Html :call Wiki2Html("all")
"------------------------------------------------------------------------------"
"}}}

" vim:fdm=marker:fmr={{{,}}} foldlevel=1:
"}}}
