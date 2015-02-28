" 给Python代码加docstring
" 参考
" https://github.com/JerryKwan/Sublime-Text-2-pydocstring
" https://github.com/heavenshell/vim-pydocstring

if exists('g:pydocstring')
    finish
endif
let g:pydocstring = 1

if !has("python")
    echo "需要python支持"
    finish
endif
let s:scriptfolder = expand('<sfile>:p:h')

function! PyDocString(...)
    "保存当前光标位置
	let save_cursor = getpos(".")
    let line = getline('.')
    let startpos = line('.')
    "光标移到第一列
    call cursor(startpos, 1)
    "从第一列搜索':'
    let insertpos = search('\:\+$')
    let lines = join(getline(startpos, insertpos))
python << EOF
import sys, os, vim
import string
import datetime
import getpass
import os.path

def construct_docstring(declaration, indent = 0):
    '''
    @summary: construct docstring according to the declaration
    @param declaration: the result of parse_declaration() reurns
    @param indent: the indent space number
    '''
    docstring = ""
    try:
        typename, name, params = declaration
        lines = []
        lines.append("'''\n")
        #lines.append("@summary: \n")
        lines.append("    \n")
        if typename == "class":
            pass
        elif typename == "def":
            if len(params):
                lines.append("\n")
                #lines.append("Parameters\n")
                #lines.append("----------\n")
                for param in params:
                    lines.append(":param %s:\n"%(param))
                    #lines.append("%s : \n"%(param))
                #lines.append("\n")
            lines.append(":return: \n")
            #lines.append("Returns\n")
            #lines.append("-------\n")
        #lines.append("'''\n")
        lines.append("'''")

        for line in lines:
            docstring += " " * indent + line

    except Exception, e:
        print e

    return docstring

def parse_declaration(declaration):
    '''
    @summary: parse the class/def declaration
    @param declaration: class/def declaration string
    @result:
        (typename, name, params)
        typename --- a string specify the type of the declaration, must be 'class' or 'def'
        name --- the name of the class/def
        params --- param list
    '''
    def rindex(l, x):
        index = -1
        if len(l) > 0:
            for i in xrange(len(l) - 1, -1, -1):
                if l[i] == x:
                    index = i
        return index

    typename = ""
    name = ""
    params = []

    tokens = {")": "(",
                "]": "[",
                "}": "{",
                }

    # extract typename
    declaration = declaration.strip()
    if declaration.startswith("class"):
        typename = "class"
        declaration = declaration[len("class"):]
    elif declaration.startswith("def"):
        typename = "def"
        declaration = declaration[len("def"):]
    else:
        typename = "unsupported"

    # extract name
    declaration = declaration.strip()
    index = declaration.find("(")
    if index > 0:
        name = declaration[:index]
        declaration = declaration[index:]
    else:
        name = "can not find the class/def name"

    # process params string
    # the params string are something like "(param1, param2=..)"
    declaration = declaration.strip()
    if declaration[-1] == ':':
        declaration = declaration[:-1]
    declaration = declaration.strip()
    #print "\nparams string is ", declaration
    if (len(declaration) >= 2) and (declaration[0] == '(') and (declaration[-1] == ')'):
        # continue process
        declaration = declaration[1:-1].strip()

        stack = []
        for c in declaration:
            if c in string.whitespace:
                if len(stack) > 0:
                    if stack[-1] in string.whitespace:
                        # previous char is whitespace too
                        # so we will discard current whitespace
                        continue
                    else:
                        # push stack
                        stack.append(" ")
                else:
                    # discard leading whitespaces
                    continue
            else:

                if c in tokens.keys():
                    # find the corresponding token
                    index = rindex(stack, tokens[c])
                    #print "c = %s, index = %s"%(c, index)
                    if index > 0:
                        # delete all of the elements between the paired tokens
                        stack = stack[:index]
                else:
                    # push stack
                    stack.append(c)

        tmp = "".join(stack)
        #print "\nstack is: ", tmp
        # split with ,
        stack = tmp.split(",")
        #print "stack is: ", "".join(stack)
        params = []
        for w in stack:
            w = w.strip()
            if w == "self":
                # skip self parameter
                continue
            index = w.find("=")
            if index > 0:
                params.append(w[:index].strip())
            else:
                params.append(w)
    else:
        params = []

    return(typename, name, params)

def get_docstring(result, declaration, tab_size=4):
    docstring = ''
    # calculate docstring indent
    indent = 0
    try:
        name = result[1]
        #print "declaration = %s, name = %s"%(declaration, name)
        index = declaration.find(name)
        if index >=0:
            for i in xrange(index):
                if declaration[i] == "\t":
                    indent += tab_size
                else:
                    indent += 1
        # calculate the real indent
        if indent % tab_size :
            indent = (indent / tab_size) * tab_size
        #print "indent = %s"%(indent)
        docstring = construct_docstring(result, indent = indent)
        #print "docstring is: \n%s" %(docstring)
        # insert class/def docstring
        # print "row = %s, col = %s"%(self.view.rowcol(declaration_region.end()))
        #self.view.insert(edit, declaration_region.end() + 2, docstring)
    except Exception, e:
        print e
    return docstring

#sys.path.append(vim.eval('s:scriptfolder'))
#from docstring import *
declaration = vim.eval("lines")
result = parse_declaration(declaration)
if result[0] != 'unsupported':
    tab_size = int(vim.eval("&ts"))
    doc = get_docstring(result, declaration, )
    pos = int(vim.eval("insertpos"))
    doc = doc.split('\n')
    vim.current.buffer.append(doc, pos)
else:
    print 'not class or function!'
EOF
    "恢复光标位置
    call setpos('.', save_cursor)
endfunc 
command! -nargs=0 PD :call PyDocString()
