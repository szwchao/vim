" Vim syntax file
" Language:	Quickfix window
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2001 Jan 15

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" A bunch of useful C keywords
syn match	qfFileName	"^[^|]*" nextgroup=qfSeparator
syn match	qfSeparator	"|" nextgroup=qfLineNr contained
syn match	qfLineNr	"[^|]*" contained contains=qfError
syn match	qfError		"error" contained
syn match       qfFunc          "<<.*>>"
syn match       Function "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
syn match       Function "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2

" The default highlighting.
hi def link qfFileName	Type
hi def link qfLineNr	LineNr
hi def link qfError	Error
hi def link qfFunc	String

let b:current_syntax = "qf"

" vim: ts=8
