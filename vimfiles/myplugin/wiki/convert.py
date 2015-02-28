# -*- coding: utf-8 -*-
#!/usr/bin/env python
import sys, os, re
import jinja2
from mako.template import Template
import markdown
from wikilink import WikiLinkExtension
from bs_table import BSTableExtension
from row import RowExtension
#from fenced_code import FencedCodeExtension
from plantuml import PlantUMLMarkdownExtension 
 
debug = True

class MarkdownConverter(object):
    def __init__(self, wiki_path, html_path, template):
        self.wiki_path = wiki_path[0].lower() + wiki_path[1:]
        self.html_path = html_path
        self.template = template
        self.image_path = os.path.join(self.html_path, "images")

    def get_all_md_files(self):
        """ 指定目录找出所有markdown文件 """
        path = self.wiki_path
        file_list = []
        if not os.path.isdir(path):
            raise Exception("floder path is None")
        for dirpath, dirnames, filenames in os.walk(path):
            for name in filenames:
                filename, ext = os.path.splitext(name)
                if ext in ['.md', '.markdown']:
                    file_list.append(os.path.join(dirpath, name))
        return file_list
    
    def parse_md_file(self, input_file, root_path):
        """提取markdown文件内容"""
        f = open(input_file, "r")
        md = unicode(f.read(), 'utf-8')
        #extensions = ['extra', 'smartypants']
        extensions=[
                #FencedCodeExtension(),
                #RowExtension(), 
                BSTableExtension(), 
                WikiLinkExtension(base_url='', end_url='.html'),
                'markdown.extensions.tables',
                'markdown.extensions.fenced_code',
                PlantUMLMarkdownExtension(
                    jar = "c:\\Vim\\tools\\plantuml\\plantuml.jar",
                    outpath=self.image_path,
                    siteurl=root_path + "images/",
                    css_class="thumbnail",
                    ),     #转换uml图
                ]
        html = markdown.markdown(md, extensions=extensions, output_format='html5')
        return html
    
    def jinja2_render(self, output_file, content, root_path):
        """ jinja2的模板输出 """
        #必须要先用sys设置一下encoding
        #reload(sys)
        #sys.setdefaultencoding('utf8')
        t = open(self.template, 'r').read()
        t = t.decode('utf-8')
        content = unicode(content, 'utf-8')
        doc = jinja2.Template(t).render(content=content, root=root_path)
        out = open(output_file, "w")
        out.write(doc)

    def mako_render(self, output_file, content, root_path):
        """ mako的模板输出 """
        t = open(self.template, 'r').read()
        t = t.decode('utf-8')
        r = Template(t)
        doc = r.render(content = content, root = root_path).encode('utf-8')
        out = open(output_file, 'w')
        out.write(doc)
        out.close()

    def convert_single_md_file_to_html(self, md_file):
        """转换单个markdown文件"""
        #盘符小写
        md_file = os.path.normpath(md_file[0].lower() + md_file[1:])
        new_file = md_file.replace(os.path.normpath(self.wiki_path)+'\\', "")  #去掉md根目录
        root_path = "../" * (len(re.split(r'[/\\]', new_file)) - 1)  #计算新路径对根目录的相对路径，重定向
        out_file = os.path.join(self.html_path, new_file)  #构造输出的html文件名，此时还是以md为扩展名
        dirname = os.path.normpath(os.path.dirname(out_file))
        if os.path.isdir(dirname) != True:
            os.makedirs(dirname)
        filename, ext = os.path.splitext(out_file)
        print "handling " + out_file
        content = self.parse_md_file(md_file, root_path)
        #self.jinja2_render(filename+'.html', content, root_path)
        self.mako_render(filename+'.html', content, root_path)
     
    def convert_all_md_files_to_html(self):
        """转换所有markdown文件"""
        md_file_list = self.get_all_md_files()
        for md_file in md_file_list:
            self.convert_single_md_file_to_html(md_file)
        
    def run(self):
        self.convert_all_md_files_to_html()
 
if __name__ == '__main__':
    #current_dir = os.path.dirname(os.path.abspath(__file__))
    wiki_path = "c:/local/My/Wiki/wiki_files/"
    html_path = "c:/local/My/Wiki/"
    template = "c:/local/My/Wiki/assets/template/template.html"
    mc = MarkdownConverter(wiki_path, html_path, template)
    mc.run()
