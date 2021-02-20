package demo;

using haxeparser.HaxeParser;

class SimpleDemo {
  public static function main() {
    var parser = new haxeparser.HaxeParser(byte.ByteData.ofString("class A {}"), "a.txt");
		var data = parser.parse();
		trace(data);
  }
}