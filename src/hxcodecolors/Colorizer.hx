package hxcodecolors;

using StringTools;
typedef DictValue = Array<Int>;
typedef StringDict = Map<String, DictValue>;

class Colorizer {
  var modifiers: StringDict;

  public function new() {
    this.modifiers = [
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
			"whiteBright" => [97, 39],

			'bold' => [1, 22],
			'dim' => [2, 22],
			'italic' => [3, 23],
			'underline' => [4, 24],
			'overline' => [53, 55],
			'inverse' => [7, 27],
			'hidden' => [8, 28],
			'strikethrough' => [9, 29]
		];
  }

  function distribute(styles: Array<String>) : Array<DictValue> {
    var prefix: DictValue = [];
    var suffix: DictValue = [];

    for(key in styles) {
      var pair = this.modifiers[key];
      prefix.unshift(pair[0]);
      suffix.push(pair[1]);
    }

    return [prefix, suffix];
  }

	static function expressTag(styles: DictValue): String {
    return styles.map((m) -> '\u001B[${m}m').join('');
	}

  public function build(styles: Array<String>): Array<String> {
    var groups = distribute(styles);
    var prefix = groups[0];
    var suffix = groups[1];

    return [expressTag(prefix), expressTag(suffix)];
  }
}