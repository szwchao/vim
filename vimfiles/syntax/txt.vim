" Vim syntax file
" Language:	PlainText
" Maintainer:	Calon <calon.xu@gmail.com>
" URL:		http://calon,weblogs.us/
" Last Update:  2010-12-12 21:00

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'txt'
endif

":so $VIMRUNTIME/syntax/html.vim

syn case ignore

syn cluster AlwaysContains add=Errors
syn cluster NormalContains add=Numbers,CPM,Links
syn cluster QuoteContains  add=Quoted,SingleQuoted,Bracketed

" English Punctuation Marks
syn match EPM "[~\-_+*<>\[\]{}=|#@$%&\\/:&\^\.,!?]"

" Normal Chinese Punctuation Marks
syn match CPM "[£¬¡££»£º£¡£¿¡¢¡¶¡·¡¾¡¿¡°¡±¡®¡¯£¨£©¡º¡»¡¸¡¹¡¼¡½©z©{¡²¡³¡´¡µ¡­£¤¡¤¡ö¡ô¡ø¡ñ¡ï¡õ¡ó¡÷¡ð¡î¡ç¡ë£¤¡æ¡ù¡À¢Å¢Æ¢Ç¢È¢É¢Ê¢Ë¢Ì¢Í¢Î¢Ï¢Ð¢Ñ¢Ò¢Ó¢Ô¢Õ¢Ö¢×¢Ø¢±¢²¢³¢´¢µ¢¶¢·¢¸¢¹¢º¢»¢¼¢½¢¾¢¿¢À¢Á¢Â¢Ã¢Ä¢Ù¢Ú¢Û¢Ü¢Ý¢Þ¢ß¢à¢á¢â¢å¢æ¢ç¢è¢é¢ê¢ë¢ì¢í¢î¡ú¡û¡ü¡ý¡ì¡í¡ò¢ñ¢ò¢ó¢ô¢õ¢ö¢÷¢ø¢ù¢ú¢û¢ü¡Ö¡Ô¡Ù£½¡Ü¡Ý£¼£¾¡Ú¡Û¡Ë¡À£«£­¡Á¡Â£¯¡Ò¡Ó¡Ø¡Þ¡Ä¡Å¡Æ¡Ç¡È¡É¡Ê¡ß¡à¡Í¡Î¡Ï¡Ð¡Ñ¡Õ¡×¡Ì¡ã¡è¡é©–]"
" Êý×Ö
syn match Numbers "\d\(\.\d\+\)\?"
syn match Numbers "\d"
syn match Links       "\(http\|https\|ftp\)\(\w\|[\-&=,?\:\.\/]\)*"   contains=CPM
syn region Bracketed         matchgroup=CPM  start="[£¨]"        end="[£©]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Quoted            matchgroup=EPM  start="\""          end="\""    contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Quoted            matchgroup=CPM  start="[¡¶]"        end="[¡·]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Quoted            matchgroup=CPM  start="[¡°]"         end="[¡±]"   contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Quoted            matchgroup=CPM  start="[¡º]"        end="[¡»]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Quoted            matchgroup=CPM  start="[¡¾]"        end="[¡¿]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Quoted            matchgroup=CPM  start="[©z]"        end="[©{]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Quoted            matchgroup=CPM  start="[¡²]"        end="[¡³]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Quoted            matchgroup=EPM  start="\(\s\|^\)\@<='"  end="'" contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region SingleQuoted      matchgroup=CPM  start="[¡´]"        end="[¡µ]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region SingleQuoted      matchgroup=CPM  start="[¡¸]"        end="[¡¹]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region SingleQuoted      matchgroup=CPM  start="[¡®]"         end="[¡¯]"   contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region SingleQuoted      matchgroup=CPM  start="[¡¼]"        end="[¡½]"  contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Comments  matchgroup=EPM         start="("       end=")"         contains=@QuoteContains,@NormalContains,@AlwaysContains
syn region Comments  matchgroup=Comments    start="\/\/"    end="$"         contains=@AlwaysContains       oneline
syn region Comments  matchgroup=Comments    start="\/\*"    end="\*\/"      contains=@AlwaysContains
syn region Tags    matchgroup=EPM start="<"        end=">"         contains=@NormalContains,@AlwaysContains oneline
syn region Tags    matchgroup=EPM start="{"        end="}"         contains=@NormalContains,@AlwaysContains oneline
syn region Tags    matchgroup=EPM start="\["       end="\]"        contains=@NormalContains,@AlwaysContains oneline 
syn keyword Errors error bug warning fatal rtfm

syn case match
" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
  if version < 508
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink Numbers              Number
  HiLink CPM                  String
  HiLink EPM                  Tag
  HiLink Bracketed            Delimiter
  HiLink Quoted               Label
  HiLink SingleQuoted         Structure
  HiLink Comments             Comment
  HiLink Links                Identifier
  HiLink Tags                 Function
  delcommand HiLink

  hi Errors                   ctermfg=red guifg=red

let b:current_syntax = "txt"

