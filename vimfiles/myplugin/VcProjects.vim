" 解析VC工程{{{1

"设置全局变量{{{2
"-----------------------------------------------------------------------------"
" Prevent reloading
if exists('g:loaded_vcproject')
   finish
endif
let g:loaded_vcproject = 1

fun! s:Set(var, val)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . string(a:val)
    end
endfun

" quickfix的临时文件
call s:Set('g:vs_output', $TEMP.'\\_vs_output.txt')
" quickfix的错误格式
call s:Set('g:vs_quickfix_errorformat', '\ %#%f(%l)\ :\ %m')
" Visual Studio的编译命令
call s:Set('g:vs_build_cmd', '"c:/Program Files (x86)/Microsoft Visual Studio 9.0/VC/vcpackages/vcbuild.exe" /Rebuild /M4 ')
"call s:Set('g:vs_quickfix_errorformat', '%f(%l)\ :\ %t%*\\D%n:\ %m,%f(%l)\ :\ %m')
"供状态条以及编译使用
call s:Set('g:current_project_name', '')
" 用默认名创建tag, cscope
call s:Set('g:VCUseDefaultTagsCscopeName', '1')
" 工程目录名
"call s:Set('g:MyProjectConfigDir', $HOME.'\MyProject')
if g:computer_enviroment == 'grundfos'
    call s:Set('g:VCProjectConfigDir', 'H:\workspace\MyProject')
else
    call s:Set('g:VCProjectConfigDir', 'D:\workspace\MyProject')
endif
" 配置列表
"call s:Set('g:VCProjectConfigFile', 'VCProjects')
let g:vcprojects = [
            \{'NFC': 'c:\local\workspace\55602_Elephant_V00.04.00\ctrleTAP_BUILD\eTAP_Build\bbElephant\Nfc\Dev\_Test_\NfcService_UnitTest\NfcService_UnitTest.vcproj'},
            \]
" 窗口高度
call s:Set('g:VCProjectWinHeight', "15")
"}}}

"调试{{{2
"-----------------------------------------------------------------------------"
let s:debugmsg = 0

fun! s:EchoError(msg)
    if s:debugmsg != 1
        return
    endif
    echohl errormsg
    redraw
    echo a:msg
    echohl normal
endfun
"}}}

"设置工程配置目录{{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   设置工程配置目录，不存在则创建目录
" @返 回 值：   1 - 成功， 0 - 失败
"* --------------------------------------------------------------------------*/
fun! s:SetVCProjectDir()
    if !isdirectory(g:VCProjectConfigDir)
        call mkdir(g:VCProjectConfigDir, "p")
        let s:vc_project_config_dir = g:VCProjectConfigDir
        return 1
    elseif exists('g:VCProjectConfigDir')
        let s:vc_project_config_dir = g:VCProjectConfigDir
        return 1
    else
        return 0
    endif
endfun

"* --------------------------------------------------------------------------*/
" @函数说明：   获取工程配置目录
" @返 回 值：   目录名称字符串
"* --------------------------------------------------------------------------*/
fun! s:GetVCProjectConfigDir()
    return s:vc_project_config_dir
endfun
"}}}

"设置所有工程{{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   
" @返 回 值：   列表s:all_vc_projects，格式: [{'name': 'path'}, {'name': 'path'}]
"* --------------------------------------------------------------------------*/
fun! s:SetAllVCProjects()
    let s:all_vc_projects = g:vcprojects
    return 1
endfun

fun! s:GetAllVCProjects()
    return s:all_vc_projects
endfun
"}}}

"设置当前工程{{{2
"-----------------------------------------------------------------------------"
fun! s:SetVCCurrentProject(cur_prj)
    let s:current_project = a:cur_prj
endfun
fun! s:GetVCCurrentProjectDict()
    if exists('s:current_project')
        return s:current_project
    else
        return {}
    endif
endfun
"}}}

"当前工程列表{{{2
"-----------------------------------------------------------------------------"
fun! s:SetVCProjectList()
    let s:vc_project_list = []
    for prj in s:GetAllVCProjects()
        for key in keys(prj)
            call add(s:vc_project_list, key)
        endfor
    endfor
endfun
fun! s:GetVCProjectNameList()
    if exists('s:vc_project_list')
        return s:vc_project_list
    endif
    return []
endfun
"}}}

" 入口 {{{2
"-----------------------------------------------------------------------------"
fun! s:InitVCProject()
    if !s:SetVCProjectDir()
        call s:EchoError('Set Project Dir Error')
    endif
    if !s:SetAllVCProjects()
        call s:EchoError('Set All Projects Error')
    endif
    call s:SetVCProjectList()
endfun

fun! StartVCProject()
    call s:InitVCProject()
    call s:DisplayVCProject(s:GetVCProjectNameList())
endfun
"}}}

" 取得光标下的工程 {{{2
"-----------------------------------------------------------------------------"
fun! s:GetProjectUnderCursor()
    let prj_name = getline('.')
    if prj_name == ''
        return {}
    endif
    let all_prjs = s:GetAllVCProjects()
    let l:cur_prj = {}
    for prj in all_prjs
        if has_key(prj, prj_name)
            let prj_path = prj[prj_name]
            let l:cur_prj['name'] = prj_name
            let l:cur_prj['path'] = prj_path
            let esc_filename_chars = ' *?[{`$%#"|!<>();&' . "'\t\n"
            let this_project_dir = escape(s:GetVCProjectConfigDir().g:slash.cur_prj['name'], esc_filename_chars)
            let l:cur_prj['tags'] = this_project_dir.g:slash."tags"
            let l:cur_prj['cscope'] = this_project_dir.g:slash."cscope.out"
            let l:cur_prj['filenametags'] = this_project_dir.g:slash."filenametags"
            let l:cur_prj['cache'] = this_project_dir.g:slash."cache"
            if !isdirectory(this_project_dir)
                call mkdir(this_project_dir, 'p')
            endif
            "echo l:cur_prj
        call s:SetVCCurrentProject(l:cur_prj)
            return l:cur_prj
        elseif
            return {}
        endif
    endfor
endfun
"-----------------------------------------------------------------------------"
"}}}

" 加载光标下的工程 {{{2
"-----------------------------------------------------------------------------"
fun! s:LoadProjectUnderCursor()
    let l:cur_prj = s:GetProjectUnderCursor()
    if l:cur_prj == {}
        echo "没有工程!"
        silent! close
        return
    endif
    if !empty(l:cur_prj)
        call s:SetTagsCscopeFilenametags()
        if exists('g:loaded_airline')
            let symbol = get(g:, 'airline#extensions#branch#symbol', g:airline_symbols.branch)
            let g:airline_section_b = symbol . GetProjectName()
            exe ":AirlineRefresh"
        endif
        exe "unmap <F5>"
        exe "nmap <F5> :call VCBuild('" . l:cur_prj['path'] . "')<CR>"
    elseif
        call s:SetVCCurrentProject({})
        echo "项目不存在!"
    endif
    call s:EchoError(l:cur_prj)
    silent! close
endfun
"-----------------------------------------------------------------------------"
"}}}

" 更新光标下的工程 {{{2
"-----------------------------------------------------------------------------"
fun! s:UpdateProjectUnderCursor()
    let cur_prj = s:GetProjectUnderCursor()
    call s:PyBuildFilenametags(cur_prj)
    call s:UpdateVCProjectTags(cur_prj['tags'])
    call s:UpdateVCProjectCscope(cur_prj['cscope'])
    call s:UpdateVCProjectCache(cur_prj['filenametags'], cur_prj['cache'])
    call s:LoadProjectUnderCursor()
endfun
"-----------------------------------------------------------------------------"
"}}}

" 设置当前工程的tags，cscope，filenametags {{{2
"-----------------------------------------------------------------------------"
fun! s:SetTagsCscopeFilenametags()
    let cur_prj = s:GetVCCurrentProjectDict()
   
    if has_key(cur_prj, "filenametags")
        if !filereadable(cur_prj["filenametags"])
            call s:PyBuildFilenametags(cur_prj)
        endif
    endif

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(cur_prj, "name")
        let g:current_project_name = cur_prj['name']
        " fuf提示符
        let g:fuf_mytaggedfile_prompt = '>'.cur_prj['name'].'>'
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(cur_prj, "tags")
        if filereadable(cur_prj["tags"])
            exe ":set tags="
            exe ":set tags+=".cur_prj["tags"]
        else
            call s:UpdateVCProjectTags(cur_prj['tags'])
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(cur_prj, "cscope")
        if filereadable(cur_prj["cscope"])
            exe ":cscope reset"
            exe ":cscope add ".cur_prj["cscope"]
        else
            call s:UpdateVCProjectCscope(cur_prj['cscope'])
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(cur_prj, "filenametags")
        if filereadable(cur_prj["filenametags"])
            let g:filenametags = cur_prj["filenametags"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "供fuf使用
    if has_key(cur_prj, "cache")
        if filereadable(cur_prj["cache"])
            let g:project_cache = cur_prj["cache"]
        else
            call s:UpdateVCProjectCache(cur_prj['filenametags'], cur_prj['cache'])
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "供MyGrep使用
    if has_key(cur_prj, "SourceCodeDir0")
        let g:project_root_dir = cur_prj["SourceCodeDir0"]
    endif
    if has_key(cur_prj, "grep_ext")
        let g:project_grep_ext = cur_prj["grep_ext"]
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "MRU
    let g:MRU_File = s:GetVCProjectConfigDir() . g:slash . cur_prj['name'] . g:slash. 'mru'
endfun
"-----------------------------------------------------------------------------"
"}}}

"显示工程列表 {{{2
"-----------------------------------------------------------------------------"
fun! s:DisplayVCProject(project_list)
    let bname = '_VC_Projects_'
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
        exe 'silent! botright ' . g:VCProjectWinHeight . 'split ' . wcmd
    endif
    " Mark the buffer as scratch
    setlocal modifiable
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nowrap
    setlocal nobuflisted
    setlocal winfixheight
    " Setup the cpoptions properly for the maps to work
    let old_cpoptions = &cpoptions
    set cpoptions&vim
    call s:VCProjectMapKeys()   
    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions
    " Display the list
    silent! 0put = a:project_list
    " Move the cursor to the beginning of the file
    normal! G"_dd
    normal! gg
    setlocal nomodifiable
    "call s:VCProjectSyntax()
    call cursor(1, 1)
endfun
"}}}

" 语法高亮 {{{2
"-----------------------------------------------------------------------------"
fun! s:VCProjectSyntax()
    syn match VCProjectList       /^[a-zA-Z0-9-_]\+$/
    hi def link VCProjectList Type
endfun
"}}}

" 快捷键 {{{2
"-----------------------------------------------------------------------------"
fun! s:VCProjectMapKeys()   
    nnoremap <buffer> <silent> <CR>          :call <SID>LoadProjectUnderCursor()<cr>
    "nnoremap <buffer> <silent> u             :call <SID>UpdateProjectUnderCursor()<cr>
    nnoremap <buffer> <silent> <ESC>         :close<CR>
    nnoremap <buffer> <silent> u             :call <SID>UpdateProjectUnderCursor()<cr>
endfun
"}}}

" 生成tags {{{2
"------------------------------------------------------------------------------"
fun! s:UpdateVCProjectTags(tags)
    let l:output_dir = fnamemodify(a:tags, ":p:h")
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if filereadable(a:tags)
        call delete(a:tags)
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    execute "cd " . l:output_dir 
    let starttime = reltime()  " start the clock
    echo "生成tags中..."
    call system("ctags -L cscope.files --c++-kinds=+p --fields=+iaS --extra=+q .")
    let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
    echo "tags已创建! ". '(time: '.elapsedtimestr.'s)'
endfun
"------------------------------------------------------------------------------"
"}}}

" 生成cscope {{{2
"-----------------------------------------------------------------------------"
fun! s:UpdateVCProjectCscope(cscope)
    let l:output_dir = fnamemodify(a:cscope, ":p:h")
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    execute "cd " . output_dir
    let starttime = reltime()  " start the clock
    echo "生成cscope中..."
    call system("cscope -bkq -i cscope.files")
    let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
    echo "cscope已创建! ". '(time: '.elapsedtimestr.'s)'
endfun
"-----------------------------------------------------------------------------"
"}}}

" 生成cache {{{2
"-----------------------------------------------------------------------------"
"生成cache，用于fuzzyfinder的taggedfile模式快速打开文件，需要先生成filenametags
function! s:UpdateVCProjectCache(filenametags, cache_file)
    if !filereadable(a:filenametags)
        echo "需要先生成filenametags"
        return
    endif
    let starttime = reltime()  " start the clock
    echo "生成cache中..."
    let tags=[a:filenametags]
    let tags = sort(filter(map(tags, 'fnamemodify(v:val, '':p'')'), 'filereadable(v:val)'))
    let cacheName = a:cache_file
    let items = l9#unique(l9#concat(map(copy(tags), 's:gettaggedfileList(v:val)')))
    call map(items, 'fuf#makePathItem(v:val, "", 0)')
    call fuf#mapToSetSerialIndex(items, 1)
    call fuf#mapToSetAbbrWithSnippedWordAsPath(items)
    call s:saveDataFile(cacheName, items)
    let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
    echo "cache已创建! " . '(time: '.elapsedtimestr.'s)'
endfunction

function s:gettaggedfileList(tagfile)
    execute 'cd ' . fnamemodify(a:tagfile, ':h')
    let result = map(l9#readFile(a:tagfile), 'matchstr(v:val, ''^[^!\t][^\t]*\t\zs[^\t]\+'')')
    call map(l9#readFile(a:tagfile), 'fnamemodify(v:val, ":p")')
    cd -
    call map(l9#readFile(a:tagfile), 'fnamemodify(v:val, ":~:.")')
    return filter(result, 'v:val =~# ''[^/\\ ]$''')
endfunction

function! s:saveDataFile(dataName, items)
    let lines = map(copy(a:items), 'string(v:val)')
    return l9#writeFile(lines, a:dataName)
endfunction
"-----------------------------------------------------------------------------"
"}}}

" 用python生成cscope.files, filenametags {{{2
"-----------------------------------------------------------------------------"
function! s:PyBuildFilenametags(cur_prj)
    echo "生成cscope.files以及filenametags文件列表中..."
python << EOF
import vim, os, sys, re
from xml.dom import minidom
path = vim.eval("a:cur_prj['path']")
cscope = vim.eval("a:cur_prj['cscope']")
filenametags = vim.eval("a:cur_prj['filenametags']")
if os.path.isfile(path):
    prj_dir = os.path.dirname(path)
    #####################先将属性文件里的宏定义转化为绝对路径#####################
    oFile = open(prj_dir + '/' +'Environment.vsprops', 'r')
    data = ''
    lines = oFile.readlines()
    lines[0] = lines[0].replace('"gb2312"', '"utf-8"')
    data = data.join(lines)
    oFile.close()
    data = data.decode('gb2312').encode('utf-8');
    lstEnv = []
    lstEnv = re.findall(r'\$\(\w*\)'.encode('utf-8'), data)
    for env in lstEnv:
        data = data.replace(env, os.getenv(env[2:-1], env))
    data = data.replace('\\', '/');
    #找到形如$()的变量
    pattern = "(\$\(.+\))(.+)"
    xmldoc = minidom.parseString(data)
    #所有宏的字典
    macros = {}
    #先将Project的根目录放入字典
    macros['$(ProjectDir)'] = prj_dir + "\\"
    user_macros = xmldoc.getElementsByTagName('UserMacro')
    for macro in user_macros:
        name = macro.attributes['Name'].value
        value = macro.attributes['Value'].value
        #匹配，分成两半，一半$()，一半剩下的路径名
        m = re.match(pattern, value)
        if m != None:
            x = m.groups()
            #判断该宏定义是否已经在字典中了
            if x[0] in macros.keys():
                #取绝对路径
                abs_path  = os.path.abspath(macros[x[0]] + '/' + x[1])
                #按宏名，路径名放入字典
                macros['$('+name+')'] = abs_path + '\\'
    #print macros
    #####################再解析vcproj文件，得到文件列表#####################
    oFile = open(path, 'r')
    data = ''
    lines = oFile.readlines()
    lines[0] = lines[0].replace('"gb2312"', '"utf-8"')
    data = data.join(lines)
    oFile.close()
    data = data.decode('gb2312').encode('utf-8');
    lstEnv = []
    lstEnv = re.findall(r'\$\(\w*\)'.encode('utf-8'), data)
    for env in lstEnv:
        data = data.replace(env, os.getenv(env[2:-1], env))
    data = data.replace('\\', '/');
    xmldoc = minidom.parseString(data)
    pattern = "(\$\(.+\))(.+)"
    srcfiles = []
    files = xmldoc.getElementsByTagName('File')
    for file in files:
        path = file.attributes['RelativePath'].value
        #判断是否以宏开头
        if path.startswith('$'):
            m = re.match(pattern, path)
            x = m.groups()
            if x[0] in macros.keys():
                #从字典中找出宏的路径加上剩下的路径
                srcfile = os.path.abspath(macros[x[0]] + x[1])
        else:
            #如果不是，项目路径加上剩下的路径，取绝对路径
            srcfile = os.path.abspath(prj_dir + '/' + path)
        srcfiles.append(srcfile)
    #print srcfiles
    #####################写入cscope.files文件#####################
    cscope_files = os.path.dirname(cscope)+'/cscope.files'
    fp = open(cscope_files, 'wb')
    for item in srcfiles:
        if os.path.isfile(item):
            fp.write(item + '\n')
    fp.close()
    #####################写入filenametags文件#####################
    fp = open(filenametags, 'wb')
    fp.write('!_TAG_FILE_SORTED   2   /2=foldcase/'+"\n")
    for item in srcfiles:
        if os.path.isfile(item):
            basename = os.path.basename(item)
            fp.write(basename + '\t' + item + '\t' + '1' + '\n')
    fp.close()
EOF
endfunction
"-----------------------------------------------------------------------------"
"}}}

" 编译VC项目，并将错误信息输出到quickfix窗口中 {{{2
"-----------------------------------------------------------------------------"
function! VCBuild(path)
    let cmd = g:vs_build_cmd . a:path . ' "Debug|Win32"'
    echo cmd
    exe 'setlocal errorformat='.g:vs_quickfix_errorformat
    let l:result = system(cmd)
    "let conv_result = l:result
    let conv_result = iconv(l:result, &enc, "utf-8")
    "echo conv_result
    let output = split(conv_result, '\n')
    "返回最后一行看是否有错误
    echo output[-1]
    call writefile(output, g:vs_output)
"用python重新编码文件为utf-8，否则乱码
python << EOF
import vim, os, sys, re
path = vim.eval("g:vs_output")
f= open(path, 'rb')
content = unicode(f.read(), 'cp936')
f.close()
f = open(path, 'w')
f.write(content.encode('utf-8'))
f.close()
EOF
    let &errorfile = g:vs_output
    "autocmd QuickFixCmdPre 
    cgetfile
endfunction

"}}}

" vim:fdm=marker:fmr={{{,}}} foldlevel=1:
"}}}
