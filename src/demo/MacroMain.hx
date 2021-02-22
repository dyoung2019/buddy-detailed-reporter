package demo;

import hxcodecolors.SimplifiedParser;

class MacroMain {
  public static function resolvePath(location: String): String {
    var path = new haxe.io.Path(location);
    var relativePath = haxe.io.Path.join([path.dir, path.file + '.' + path.ext]); // path/to/file.txt
    return haxe.io.Path.normalize(relativePath);    
  }

  public static function splitIntoLines(text: String) {
		var vals = ~/[\n\r|\r\n|\r]/g;
		return vals.split(text);
  }

  public static function colorize(path: String): String {
    var content = sys.io.File.getContent(path);
    try {
      var inputData = byte.ByteData.ofString(content);
      // var inputData = byte.ByteData.ofString('12 import() demo.quarter; "hello world" "demo" "hard" "ab"');
      var parser = new SimplifiedParser(inputData, path);
      return parser.colorise();
    }
    catch(e: Dynamic) {
      trace(e);
      return content;
    }
  }


  public static function main() {
    for (arg in Sys.args()) {
      var filePath = resolvePath(arg);
      var summary = colorize(filePath);
      var lines = splitIntoLines(summary);
      for (line in lines) {
        trace(line);
      }
    }
  }

}