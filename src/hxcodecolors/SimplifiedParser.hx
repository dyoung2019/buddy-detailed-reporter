package hxcodecolors;

class SimplifiedParser extends hxparse.Parser<hxparse.LexerTokenSource<Token>, Token> {
  public function new(input:byte.ByteData, sourceName:String) {
    var lexer = new SimplifiedLexer(input, sourceName);
    var ts = new hxparse.LexerTokenSource(lexer, SimplifiedLexer.tok);
		super(ts);
  }

	public function colorise(): Dynamic {
		var contents = new StringBuf();
		
		var keepGoing = true;
		var item = null;
		 do {
			 item = hxparse.Parser.parse(switch stream {
				case [TString(s)]: 
					'"' + s + '"';
				case [TNumber(s)]: 
					'no' + s + 'no';
				case [TIdentifier(s)]: 
					'id' + s + 'id';
				case [TKeyword(_, s)]: 
					'kw' + s + 'kw'; // package info
				case [TOperator(_, s)]: 
					'op' + s + 'op'; // package info
				case [TParenthesis(_, s)]:
					'pt' + s + 'pt';
				case [TWspace(s)]:
					s;
				case [TEof]:
					keepGoing = false;
					null;
				});
			
			if (item != null) {
				contents.add(item);
			}
		} while(keepGoing);
		return contents.toString();
	}
	// simpleQualifiedReferenceExpression ::= referenceExpression qualifiedReferenceExpression * { elementType="referenceExpression"}
}