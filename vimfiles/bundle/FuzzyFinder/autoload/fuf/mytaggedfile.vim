"=============================================================================
" Copyright (c) 2007-2010 Takeshi NISHIDA
"
"=============================================================================
" LOAD GUARD {{{1

if !l9#guardScriptLoading(expand('<sfile>:p'), 0, 0, [])
  finish
endif

" }}}1
"=============================================================================
" GLOBAL FUNCTIONS {{{1

"
function fuf#mytaggedfile#createHandler(base)
  return a:base.concretize(copy(s:handler))
endfunction

"
function fuf#mytaggedfile#getSwitchOrder()
  return g:fuf_mytaggedfile_switchOrder
endfunction

"
function fuf#mytaggedfile#getEditableDataNames()
  return []
endfunction

"
function fuf#mytaggedfile#renewCache()
  let s:cache = {}
endfunction

"
function fuf#mytaggedfile#requiresOnCommandPre()
  return 0
endfunction

"
function fuf#mytaggedfile#onInit()
  call fuf#defineLaunchCommand('FufMyProject', s:MODE_NAME, '""', [])
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTIONS/VARIABLES {{{1

let s:MODE_NAME = expand('<sfile>:t:r')

function s:readCache()
  let cache_file = g:project_cache
  let lines = l9#readFile(cache_file)
  return map(lines, 'eval(v:val)')
endfunction

"
function s:getmytaggedfileList(tagfile)
  execute 'cd ' . fnamemodify(a:tagfile, ':h')
  let result = map(l9#readFile(a:tagfile), 'matchstr(v:val, ''^[^!\t][^\t]*\t\zs[^\t]\+'')')
  call map(l9#readFile(a:tagfile), 'fnamemodify(v:val, ":p")')
  cd -
  call map(l9#readFile(a:tagfile), 'fnamemodify(v:val, ":~:.")')
  return filter(result, 'v:val =~# ''[^/\\ ]$''')
endfunction

"
function s:parseTagFiles(tagFiles, key)
  "hash算一个cache文件
  let cacheName = 'cache-' . l9#hash224(a:key)
  let cacheTime = fuf#getDataFileTime(s:MODE_NAME, cacheName)
  if cacheTime != -1 && fuf#countModifiedFiles(a:tagFiles, cacheTime) == 0
    return fuf#loadDataFile(s:MODE_NAME, cacheName)
  endif
  let items = l9#unique(l9#concat(map(copy(a:tagFiles), 's:getmytaggedfileList(v:val)')))
  call map(items, 'fuf#makePathItem(v:val, "", 0)')
  call fuf#mapToSetSerialIndex(items, 1)
  call fuf#mapToSetAbbrWithSnippedWordAsPath(items)
  call fuf#saveDataFile(s:MODE_NAME, cacheName, items)
  return items
endfunction

"
function s:enummytaggedfiles(tagFiles)
  if !len(a:tagFiles)
    return []
  endif
  let key = join([getcwd(), g:fuf_ignoreCase] + a:tagFiles, "\n")
  if !exists('s:cache[key]') || fuf#countModifiedFiles(a:tagFiles, s:cache[key].time)
    let s:cache[key] = {
          \   'time'  : localtime(),
          \   'items' : s:parseTagFiles(a:tagFiles, key)
          \ }
  endif
  return s:cache[key].items
endfunction

function s:getCurrentProjectTagFiles()
   if exists('g:filenametags')
      "设置一个局部tags变量，供下面的tagfiles()调用,此filenametag只能在哪里生成在哪里使用
      let tags=[g:filenametags]
      return sort(filter(map(tags, 'fnamemodify(v:val, '':p'')'), 'filereadable(v:val)'))
   else
      return sort(filter(map(tagfiles(), 'fnamemodify(v:val, '':p'')'), 'filereadable(v:val)'))
   endif
endfunction
" }}}1
"=============================================================================
" s:handler {{{1

let s:handler = {}

"
function s:handler.getModeName()
  return s:MODE_NAME
endfunction

"
function s:handler.getPrompt()
  return fuf#formatPrompt(g:fuf_mytaggedfile_prompt, self.partialMatching, '')
endfunction

"
function s:handler.getPreviewHeight()
  return g:fuf_previewHeight
endfunction

"
function s:handler.isOpenable(enteredPattern)
  return 1
endfunction

"
function s:handler.makePatternSet(patternBase)
  return fuf#makePatternSet(a:patternBase, 's:interpretPrimaryPatternForPath',
        \                   self.partialMatching)
endfunction

"
function s:handler.makePreviewLines(word, count)
  return fuf#makePreviewLinesForFile(a:word, a:count, self.getPreviewHeight())
endfunction

"
function s:handler.getCompleteItems(patternPrimary)
  return self.items
endfunction

"
function s:handler.onOpen(word, mode)
  call fuf#openFile(a:word, a:mode, g:fuf_reuseWindow)
endfunction

"
function s:handler.onModeEnterPre()
  let self.tagFiles = s:getCurrentProjectTagFiles()
endfunction

"
function s:handler.onModeEnterPost()
  " NOTE: Comparing filenames is faster than bufnr('^' . fname . '$')
  let bufNamePrev = fnamemodify(bufname(self.bufNrPrev), ':p:~:.')
  " NOTE: Don't do this in onModeEnterPre()
  "       because that should return in a short time.
  if exists('g:project_cache')
    "如果有工程，读取cache
    let self.items = copy(s:readCache())
  else
    let self.items = copy(s:enummytaggedfiles(self.tagFiles))
  endif
  call filter(self.items, 'v:val.word !=# bufNamePrev')
endfunction

"
function s:handler.onModeLeavePost(opened)
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:
