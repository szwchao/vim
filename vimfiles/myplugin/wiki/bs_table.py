# -*- coding: utf-8 -*-
##后置处理器
from markdown.postprocessors import Postprocessor
class TablePostprocessor(Postprocessor):
    def run(self, text):
        t_list = []
        for line in text.split('\n'):
            if '<table>' in line:
                line = line.replace('<table>', '<table class="table table-bordered table-striped table-hover">')
            t_list.append(line)
        return '\n'.join(t_list)
    
##扩展主体类        
from markdown.extensions import Extension
class BSTableExtension(Extension):
    def __init__(self, configs={}):
        self.config = configs

    def extendMarkdown(self, md, md_globals):
        ##注册扩展，用于markdown.reset时扩展同时reset
        md.registerExtension(self)   
                
        ##设置Postprocessor
        tablepostprocessor = TablePostprocessor()
        #print md.postprocessors.keys()
        md.postprocessors.add('tablepostprocessor', tablepostprocessor, '>unescape')
        
        ##print md_globals   ##markdown全局变量

def makeExtension(*args, **kwargs):
    return BSTableExtension(*args, **kwargs)
