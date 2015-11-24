let s:scriptfolder = expand('<sfile>:p:h')

"let s:source = {
      "\ 'name' : 'english',
      "\ 'kind' : 'manual',
      "\ 'filetypes' : { 'text' : 1, 'txt' : 1 },
      "\ 'mark' : '[en]',
      "\ 'max_candidates' : 20,
      "\ 'min_pattern_length' : 3,
      "\ 'is_volatile': 1,
      "\ }
let s:source = {
	\ 'name': 'spell',
	\ 'kind': 'keyword',
	\ 'mark': '[词典]',
	\ 'rank': 1,
	\ 'matchers': ['matcher_head'],
	\ 'max_candidates': 20,
	\ 'is_volatile': 1,
    \ 'hooks' : {},
	\ }

function! neocomplete#sources#english#define() "{{{
    return s:source
endfunction"}}}

function! s:source.hooks.on_init(context) "{{{
    let s:lines = readfile(s:scriptfolder . '/english.txt')
endfunction"}}}

function! s:source.gather_candidates(context) "{{{
    "if (neocomplete#is_text_mode() && a:context.complete_str !~# '[[:alpha:]]\+$')
    " 只有纯文本或注释里才返回补全列表
    if !(neocomplete#is_text_mode() || neocomplete#within_comment() || neocomplete#get_context_filetype() == 'nothing') || a:context.complete_str !~ '^[[:alpha:]]\+$'
        return []
    endif
    "return neocomplete#sources#english#grep_get_candidates(a:context)
    return neocomplete#sources#english#vim_get_candidates(a:context)

endfunction"}}}

function! neocomplete#sources#english#vim_get_candidates(context) "{{{
    let suggestions = []
    for line in s:lines
        if matchstr(line, '^'.a:context.complete_str) != ''
            let record = split(line, '\t\t\t')
            let candidate = {
                        \ 'word' : record[0],
                        \ 'menu' : '[词典]',
                        \ }
            let len_word = strlen(record[0])
            if len_word < 30
                let abbr = record[0] . repeat(' ', (30 - len_word)) . record[1]
            endif
            let candidate['abbr'] = abbr
            call add(suggestions, candidate)
        endif
    endfor
    return suggestions
endfunction"}}}

function! neocomplete#sources#english#grep_get_candidates(context) "{{{
    let suggestions = []
    let newWords = system('grep "^'. a:context.complete_str . '" ' . s:scriptfolder . '/english.dict')
    let wordList = split(newWords, "\n")
    "定义单词最大长度，用于补空格，使格式整齐
    let max_len_word = 20
    " get max length of word
    "for t_word in wordList
        "let record = split(t_word, '\t\t\t\t')
        "let l = strlen(record[0])
        "if l > max_len_word
            "let max_len_word = l
        "endif
    "endfor
    for t_word in wordList
        "let record = split(t_word, '\t\t\t\t')
        let record = split(t_word, '\t\t\t')
        let candidate = {
                    \ 'word' : record[0],
                    \ 'menu' : '[词典]',
                    \ }
        let len_word = strlen(record[0])
        if len_word < max_len_word
            let abbr = record[0] . repeat(' ', (max_len_word - len_word)) . record[1]
        endif
        let candidate['abbr'] = abbr
        call add(suggestions, candidate)
    endfor
    return suggestions
endfunction"}}}

" vim: foldmethod=marker
