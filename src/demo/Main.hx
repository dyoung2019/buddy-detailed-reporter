package demo;

using StringTools;

typedef StringDict = Map<String, Array<Int>>;

class Main {

	static function expressTag(key: String, dictionary: StringDict): Array<String> {
		var keyValue = dictionary[key];
		if (key != null && keyValue != null) {
			var start = keyValue[0];
			var end = keyValue[1];
			return ['\u001B[${start}m', '\u001B[${end}m'];
		} else {
			return null;
		}
	}

	public static function expressColor(color:String): Array<String> {
		var textColors: StringDict = [
			"black" => [30, 39],
			"red" => [31, 39],
			"green" => [32, 39],
			"yellow" => [33, 39],
			"blue" => [34, 39],
			"magenta" => [35, 39],
			"cyan" => [36, 39],
			"white" => [37, 39],

			"blackBright" => [90, 39],
			"redBright" => [91, 39],
			"greenBright" => [92, 39],
			"yellowBright" => [93, 39],
			"blueBright" => [94, 39],
			"magentaBright" => [95, 39],
			"cyanBright" => [96, 39],
			"whiteBright" => [97, 39]
		];

		return Main.expressTag(color, textColors);
	}

	public static function insertColorTag(regExp: EReg, html: String, color: String):String {
		var styleTag = Main.expressColor(color);
		return regExp.replace(html, styleTag[0] + '$1' + styleTag[1]);
	}

	/**
	   Syntax highlight Haxe code.
	   
	   | Description | Applied CSS class |
	   |---|---|
	   | Reserved keywords | .kwd |
	   | Reserved values | .val |
	   | Types | .type |
	   | Strings | .str |
	   | Comments | .cmt |
	   
	   @return HTML text of highlighted code.
	**/
	public static function syntaxHighlightHaxe(code:String):String {
		var html = code;
		var kwds = ["abstract", "trace", "break", "case", "cast", "class", "continue", "default", "do", "dynamic", "else", "elseif", "enum", "extends", "extern", "for", "function", "if", "implements", "import", "in", "inline", "interface", "macro", "new", "override", "package", "private", "public", "return", "static", "switch", "throw", "try", "typedef", "untyped", "using", "var", "while", "as"];
		var kwds = new EReg("\\b(" + kwds.join("|") + ")\\b", "g");

		var vals = ["null", "true", "false", "this"];
		var vals = new EReg("[^\"].*\\b(" + vals.join("|") + ")\\b", "g");

		var types = ~/\b([A-Z][a-zA-Z0-9_]*)\b/g;
		var regexp = ~/(~\/(.+?)\/[igm])/g;

		html = html.replace("\t", "  "); // indent with two spaces

		html = insertColorTag(~/(\/\/.+?)(\n|$)/g, html, 'green'); // comments
		html = insertColorTag(~/(("|')[^"']*\2)/g, html, 'red'); // strings
		html = insertColorTag(~/(\/\*\*?(.|\n)+?\*?\*\/)/g, html, 'green'); // comments

		html = insertColorTag(kwds, html, 'blueBright'); // reserved words

		html = insertColorTag(vals, html, 'green'); // values

		html = insertColorTag(types, html, 'cyanBright'); // types

		html = insertColorTag(regexp, html, 'magenta'); // regexp
		
		return html;
	}

  public static function main(): Void {
    // trace(Main.syntaxHighlightHaxe('function demo();'));

    var location = "src/demo/Main.hx";
    var path = new haxe.io.Path(location);
    // trace(path.dir); // path/to
    // trace(path.file); // file
    // trace(path.ext); // txt

    var relativePath = haxe.io.Path.join([path.dir, path.file + '.' + path.ext]); // path/to/file.txt
    var filePath = haxe.io.Path.normalize(relativePath);

    var content:String = sys.io.File.getContent(filePath);

		var vals = ~/[\n\r|\r\n|\r]/g;
		var lines = vals.split(content);

		var lineNumber = 83;
		var lineIndex = lineNumber - 1;
		var beginning = lineIndex - 2;
		var end = lineIndex + 3;

		for (i in beginning...end) {
			trace(i + 1, Main.syntaxHighlightHaxe(lines[i]));
		}

  }
}