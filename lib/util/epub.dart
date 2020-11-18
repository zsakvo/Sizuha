class EpubUtil {
  static String contentOpf = '''<?xml version="1.0" encoding="utf-8"?>

<package xmlns="http://www.idpf.org/2007/opf" xmlns:dc="http://purl.org/dc/elements/1.1/" unique-identifier="bookid" version="2.0">  
  <metadata xmlns:opf="http://www.idpf.org/2007/opf">  
    <dc:title>&title</dc:title>  
    <dc:creator>&creator</dc:creator>  
    <dc:description>&description</dc:description>  
    <dc:language>zh-cn</dc:language>  
    <dc:date/>  
    <dc:contributor>&contributor</dc:contributor>  
    <dc:publisher>&publisher</dc:publisher>  
    <dc:subject>&subject</dc:subject> 
  </metadata>  
  <manifest> 
    &hrefs  
    <item href="catalog.xhtml" id="catalog" media-type="application/xhtml+xml"/>  
    <item href="stylesheet.css" id="css" media-type="text/css"/>  
    <item href="page.xhtml" id="page" media-type="application/xhtml+xml"/>  
    <item href="toc.ncx" media-type="application/x-dtbncx+xml" id="ncx"/> 
  </manifest>  
  <spine toc="ncx"> 
    <itemref idref="page"/>  
    <itemref idref="catalog"/>  
    &ids  
    <itemref idref="page"/>
  </spine>  
  <guide> 
    <reference href="catalog.xhtml" type="toc" title="目录"/> 
  </guide> 
</package>
''';

  static String mimetype = '''application/epub+zip''';

  static String page = '''<?xml version="1.0" encoding="utf-8" standalone="no"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>书籍信息</title>
    <style type="text/css" title="override_css">
      @page {
        padding: 0pt;
        margin: 0pt;
      }
      body {
        text-align: left;
        padding: 0pt;
        margin: 0pt;
        font-size: 1em;
      }
      ul,
      li {
        list-style-type: none;
        margin: 0;
        padding: 0;
        line-height: 2.5em;
        font-size: 0.8em;
      }
      div,
      h1,
      h2 {
        margin: 0pt;
        padding: 0pt;
      }
      h1 {
        font-size: 1.2em;
      }
      h2 {
        font-size: 1.1em;
      }
      .copyright {
        color: #ff4500;
      }
    </style>
  </head>
  <body>
    <div>
      <h1>&title</h1>
      <h2>作者：&author</h2>
      <ul>
        <li>
          内容简介：
          　　&intro
        </li>
      </ul>
    </div>
  </body>
</html>
''';

  static String style = '''body {
  margin: 10px;
  font-size: 1em;
}
ul,
li {
  list-style-type: none;
  margin: 0;
  padding: 0;
}

p {
  text-indent: 2em;
  line-height: 1.5em;
  margin-top: 0;
  margin-bottom: 1.5em;
}

.catalog {
  line-height: 2.5em;
  font-size: 0.8em;
}
li {
  border-bottom: 1px solid #d5d5d5;
}
h1 {
  font-size: 1.6em;
  font-weight: bold;
}

h2 {
  display: block;
  font-size: 1.2em;
  font-weight: bold;
  margin-bottom: 0.83em;
  margin-left: 0;
  margin-right: 0;
  margin-top: 1em;
}

.mbppagebreak {
  display: block;
  margin-bottom: 0;
  margin-left: 0;
  margin-right: 0;
  margin-top: 0;
}
a {
  color: inherit;
  text-decoration: none;
  cursor: default;
}
a[href] {
  color: blue;
  text-decoration: none;
  cursor: pointer;
}

.italic {
  font-style: italic;
}
''';

  static String tocNcx = '''<?xml version="1.0" encoding="utf-8"?>

<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">  
  <head>  
    <meta content="2" name="dtb:depth"/>  
    <meta content="&generator" name="dtb:generator"/>   
  </head>  
  <docTitle> 
    <text>&title</text> 
  </docTitle>  
  <docAuthor> 
    <text>&author</text> 
  </docAuthor>  
  <navMap>
    &navs
  </navMap>
</ncx>
''';

  static String catalog =
      '''<?xml version="1.0" encoding="utf-8" standalone="no"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN">
  <head>
    <title>&title</title>
    <link href="stylesheet.css" type="text/css" rel="stylesheet" />
    <style type="text/css">
      @page {
        margin-bottom: 5pt;
        margin-top: 5pt;
      }
    </style>
  </head>
  <body>
    <h1>目录<br />Content</h1>
    <ul> 
      &lis
    </ul>
    <div class="mbppagebreak"></div>
  </body>
</html>
''';

  static String container = '''<?xml version="1.0"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
   <rootfiles>
      <rootfile full-path="content.opf" media-type="application/oebps-package+xml"/>
   </rootfiles>
</container>''';

  static String chapter =
      '''<?xml version="1.0" encoding="utf-8" standalone="no"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN">
<head>
<title>&title</title>
<link href="stylesheet.css" type="text/css" rel="stylesheet"/><style type="text/css">
@page { margin-bottom: 5.000000pt; margin-top: 5.000000pt; }</style>
</head>
<body>
<h2><span style="border-bottom:1px solid">&title</span></h2>&ps<div class="mbppagebreak"></div></body></html>''';
}
