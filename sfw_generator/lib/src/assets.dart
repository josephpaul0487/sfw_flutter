
class Assets {


  createSfwHtml() {
    StringBuffer buffer=StringBuffer();
    buffer.writeln("class SfwHtmlParser {");//CLASS SfwHtmlParser START
    buffer.writeln("static SfwHtmlParser parser;");
    buffer.writeln("HtmlParser _htmlParser=HtmlParser();");
    buffer.writeln("static SfwHtmlParser getInstance() {");//GET INSTANCE
    buffer.writeln("if(parser==null) {");//GET INSTANCE IF
    buffer.writeln("parser=SfwHtmlParser();");
    buffer.writeln("}");//GET INSTANCE IF END
    buffer.writeln("return parser;");
    buffer.writeln("}");//GET INSTANCE END
    buffer.writeln("TextSpan getSpan(BuildContext context,String data) {");//GET SPAN
    buffer.writeln("List nodes        = _htmlParser.parse(data);");
    buffer.writeln("return this._stackToTextSpan(nodes, context);");
    buffer.writeln("}");//GET SPAN END
    buffer.writeln("RichText getWidget(BuildContext context,String data) {");//GET WIDGET
    buffer.writeln("return RichText(text: getSpan(context,data));");
    buffer.writeln("}");//GET WIDGET END
    buffer.writeln("TextSpan _stackToTextSpan(List nodes, BuildContext context) {");//_stackToTextSpan
    buffer.writeln("List<TextSpan> children = <TextSpan>[];");
    buffer.writeln("for (int i = 0; i < nodes.length; i++) {");//FOR START
    buffer.writeln("children.add(_textSpan(nodes[i]));");
    buffer.writeln("}");//FOR END
    buffer.writeln("return new TextSpan(text:'',style:DefaultTextStyle.of(context).style,children: children);");
    buffer.writeln("}");//_stackToTextSpan END
    buffer.writeln("TextSpan _textSpan(Map node) {");//_textSpan
    buffer.writeln("TextSpan span = new TextSpan(text: node['text'], style: node['style']);");
    buffer.writeln("return span;");
    buffer.writeln("}");//_textSpan END
    buffer.writeln("}");//CLASS SfwHtmlParser END


    buffer.writeln("class HtmlParser {");//CLASS HtmlParser START
    buffer.writeln("// Regular Expressions for parsing tags and attributes");
    buffer.writeln("RegExp _startTag,_endTag,_attr,_style,_color;");
    buffer.writeln(" final List _emptyTags = const ['area', 'base', 'basefont', 'br', 'col', 'frame', 'hr', 'img', 'input','isindex', 'link', 'meta', 'param', 'embed'];");
    buffer.writeln("final List _blockTags = const ['address', 'applet', 'blockquote', 'button', 'center', 'dd', 'del', 'dir','div', 'dl', 'dt', 'fieldset', 'form', 'frameset', 'hr', 'iframe', 'ins','isindex', 'li', 'map', 'menu', 'noframes', 'noscript', 'object', 'ol','p', 'pre', 'script', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead','tr', 'ul'];");
    buffer.writeln("final List _inlineTags    = const ['a', 'abbr', 'acronym', 'applet', 'b', 'basefont', 'bdo', 'big', 'br', 'button','cite', 'code', 'del', 'dfn', 'em', 'font', 'i', 'iframe', 'img', 'input','ins', 'kbd', 'label', 'map', 'object', 'q', 's', 'samp', 'script','select', 'small', 'span', 'strike', 'strong', 'sub', 'sup', 'textarea','tt', 'u', 'var'];");
    buffer.writeln("final List _closeSelfTags = const ['colgroup', 'dd', 'dt', 'li', 'options', 'p', 'td', 'tfoot', 'th', 'thead', 'tr'];");
    buffer.writeln("final List _fillAttrs     = const ['checked', 'compact', 'declare', 'defer', 'disabled', 'ismap', 'multiple','nohref', 'noresize', 'noshade', 'nowrap', 'readonly', 'selected'];");
    buffer.writeln("final List _specialTags   = const ['script', 'style'];");
    buffer.writeln("List _stack  = [];");
    buffer.writeln("List _result = [];");
    buffer.writeln("Map<String, dynamic> _tag;");
    buffer.writeln("// =================================================================================================================");
    buffer.writeln("HtmlParser() {");//CONSTRUCTOR
    buffer.writeln('this._startTag = new RegExp(r\'^<([-A-Za-z0-9_]+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")\' + "|(?:\'[^\']*\')|[^>\s]+))?)*)\s*(\/?)>");');
    buffer.writeln(' this._endTag   = new RegExp("^<\/([-A-Za-z0-9_]+)[^>]*>");');
    buffer.writeln('this._attr     = new RegExp(r\'([-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")\' + r"|(?:\'((?:\\.|[^\'])*)\')|([^>\s]+)))?");');
    buffer.writeln('this._style    = new RegExp(r\'([a-zA-Z\-]+)\s*:\s*([^;]*)\');');
    buffer.writeln("this._color    = new RegExp(r'^#([a-fA-F0-9]{6})\$');");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    buffer.writeln("");
    return buffer;
  }
}