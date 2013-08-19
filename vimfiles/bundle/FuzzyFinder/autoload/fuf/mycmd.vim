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
function fuf#mycmd#createHandler(base)
  return a:base.concretize(copy(s:handler))
endfunction

"
function fuf#mycmd#getSwitchOrder()
  return -1
endfunction

"
function fuf#mycmd#getEditableDataNames()
  return []
endfunction

"
function fuf#mycmd#renewCache()
endfunction

"
function fuf#mycmd#requiresOnCommandPre()
  return 0
endfunction

"
function fuf#mycmd#onInit()
endfunction

"
function fuf#mycmd#launch(initialPattern, partialMatching, prompt)
  let s:prompt = (empty(a:prompt) ? '>' : a:prompt)
  call GetMyCmd()
  call map(s:items, 'fuf#makeNonPathItem(v:val, "")')
  call fuf#mapToSetSerialIndex(s:items, 1)
  call map(s:items, 'fuf#setAbbrWithFormattedWord(v:val, 1)')
  call fuf#launch(s:MODE_NAME, a:initialPattern, a:partialMatching)
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTIONS/VARIABLES {{{1

let s:MODE_NAME = expand('<sfile>:t:r')
fun GetMyCmd()
   let temp_items = GetAllCommands()
   let s:cmditems = []
   let s:items = []
   for i in range(len(temp_items))
      if (temp_items[i][0] != '') || (temp_items[i][1] != '')
         call add(s:cmditems, temp_items[i])
         call add(s:items, temp_items[i][0])
      endif
   endfor
   for i in range(len(s:cmditems))
      call add(s:items, s:cmditems[i][0])
   endfor
endfun

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
  return fuf#formatPrompt(g:fuf_mycmd_prompt, self.partialMatching, '')
endfunction

"
function s:handler.getPreviewHeight()
  return 0
endfunction

"
function s:handler.isOpenable(enteredPattern)
  return 1
endfunction

"
function s:handler.makePatternSet(patternBase)
  return fuf#makePatternSet(a:patternBase, 's:interpretPrimaryPatternForNonPath',
        \                   self.partialMatching)
endfunction

"
function s:handler.makePreviewLines(word, count)
  return []
endfunction

"
function s:handler.getCompleteItems(patternPrimary)
  return s:items
endfunction

"
function s:handler.onOpen(word, mode)
  if a:word[0] =~# '[:/?]'
    call histadd(a:word[0], a:word[1:])
  endif
  for i in range(len(s:cmditems))
     if s:cmditems[i][0] == a:word
        let cmd = s:cmditems[i][1]
        let oncr = s:cmditems[i][2]
     endif
  endfor
  if oncr == 1
     call feedkeys(cmd . "\<CR>", 'n')
  else
     call feedkeys(cmd, 't')
  endif
endfunction

"
function s:handler.onModeEnterPre()
endfunction

"
function s:handler.onModeEnterPost()
endfunction

"
function s:handler.onModeLeavePost(opened)
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:
