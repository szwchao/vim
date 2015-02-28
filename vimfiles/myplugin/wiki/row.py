# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import unicode_literals
from markdown.extensions import Extension
from markdown.preprocessors import Preprocessor
from markdown.postprocessors import Postprocessor
from markdown.inlinepatterns import SimpleTagPattern
import re

class RowExtension(Extension):

    def extendMarkdown(self, md, md_globals):
        """ Add RowPostprocessor to the Markdown instance. """
        md.registerExtension(self)
        md.postprocessors.add('row',
                             RowPostprocessor(md),
                             '>unescape',
                             )

class RowPostprocessor(Postprocessor):
    ROW_RE = re.compile(r'''
(?P<row>^(?:\^{9,}|\@{9,}))[ ]*         # Opening ``` or ~~~
(\{?\.?(?P<lang>[a-zA-Z0-9_+-]*))?[ ]*  # Optional {, and lang
# Optional highlight lines, single- or double-quote-delimited
(hl_lines=(?P<quot>"|')(?P<hl_lines>.*?)(?P=quot))?[ ]*
}?[ ]*\n                                # Optional closing }
(?P<content>.*?)(?<=\n)
(?P=row)[ ]*$''', re.MULTILINE | re.DOTALL | re.VERBOSE)
    ROW_WRAP = '<div class="col-md-6">%s</div>'

    def __init__(self, md):
        super(RowPostprocessor, self).__init__(md)

    def run(self, lines):
        """ Match and store Fenced Code Blocks in the HtmlStash. """
        text = "\n".join(lines)
        while 1:
            m = self.ROW_RE.search(text)
            if m:
                code = self.ROW_WRAP % (self._escape(m.group('content')))
                #print code
                placeholder = self.markdown.htmlStash.store(code, safe=True)
                text = '%s\n%s\n%s' % (text[:m.start()],
                                       placeholder,
                                       text[m.end():])
            else:
                break
        return text.split("\n")

    def _escape(self, txt):
        """ basic html escaping """
        txt = txt.replace('&', '&amp;')
        txt = txt.replace('<', '&lt;')
        txt = txt.replace('>', '&gt;')
        txt = txt.replace('"', '&quot;')
        return txt

def makeExtension(*args, **kwargs):
    #return RowExtension(*args, **kwargs)
    #return SubscriptExtension(*args, **kwargs)
    #return ChecklistExtension()
    return LessFrameworkExtension()

# match ~, at least one character that is not ~, and ~ again
SUBSCRIPT_RE = r'(\^{9,})([^\^]{9,})\2'


def makeExtension(*args, **kwargs):
    """Inform Markdown of the existence of the extension."""


class SubscriptExtension(Extension):
    """Extension: text between ~ characters will be subscripted."""

    def extendMarkdown(self, md, md_globals):
        """Insert 'subscript' pattern before 'not_strong' pattern."""
        md.inlinePatterns.add('subscript',
                              SimpleTagPattern(SUBSCRIPT_RE, 'div'),
                              '<not_strong')


class ChecklistExtension(Extension):

    def extendMarkdown(self, md, md_globals):
        md.postprocessors.add('checklist', ChecklistPostprocessor(md),
                '>raw_html')

