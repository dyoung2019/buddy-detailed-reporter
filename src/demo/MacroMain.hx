package demo;

import haxeparser.Data;
import haxe.macro.Expr;
import haxe.ds.Option;

private enum KeywordTerm {
	KtBreak;
	KtDefault;
	KtPackage;
	KtFunction;
	KtCase;
	KtCast;
	KtAbstract;
	KtFrom;
	KtTo;
	KtClass;
	KtEnum;
	KtInterface;
	KtImplements;
	KtExtends;
	KtNull;
	KtTrue;
	KtFalse;
	KtThis;
	KtSuper;
	KtIf;
	KtFor;
	KtDo;
	KtWhile;
	KtReturn;
	KtImport;
	KtUsing;
	KtContinue;
	KtElse;
	KtSwitch;
	KtThrow;
	KtVar;
	KtFinal;
	KtStatic;
	KtPublic;
	KtPrivate;
	KtDynamic;
	KtNever;
	KtOverride;
	KtInline;
	KtMacro;
	KtUntyped;
	KtTypedef;
	KtExtern;
	KtTry;
	KtCatch;
	KtWildcard;
}

private enum OperatorTerm {
	OtColon;
	OtSemi;
	OtComma;
	OtDot;
	OtEq;
	OtAssign;
	OtNotEq;
	OtNot;
	OtComplement;
	OtPlusPlus;
	OtPlusAssign;
	OtPlus;
	OtMinusMinus;
	OtMinusAssign;
	OtMinus;
	OtQuest;
	OtCondOr;
	OtBitOr;
	OtBitOrAssign;
	OtCondAnd;
	OtBitAndAssign;
	OtBitAnd;
	OtShiftLeftAssign;
	OtShiftLeft;
	OtLessOrEq;
	OtLess;
	OtBitXorAssign;
	OtBitXor;
	OtMulAssign;
	OtMul;
	OtQuotAssign;
	OtQuot;
	OtRemAssign;
	OtRem;
	OtUShiftRAssign;
	OtShiftRAssign;
	OtShiftR;
	OtUShiftR;
	OtGreaterOrEq;
	OtGreater;
	OtTripleDot;
	OtIn;
	OtArrow;
	OtFatArrow;
	OtNew;
}

private enum ParenthesisTerm {
	PtLeftCurly;
	PtRightCurly;
	PtLeftBracket;
	PtRightBracket;
	PtLeftParen;
	PtRightParen;
}

private enum Token {
  TString(v:String);
  TNumber(v:String);
	TIdentifier(v:String);
	TOperator(ot:OperatorTerm, s: String);
	TKeyword(kt:KeywordTerm, s: String);
	TParenthesis(pt:ParenthesisTerm, s:String);
	TWspace(s:String);
  TEof;
}

class DudeLexer extends hxparse.Lexer implements hxparse.RuleBuilder {
  static var buf:StringBuf;

  static public var tok = @:rule [
		"[\\{]" => TParenthesis(PtLeftCurly, lexer.current),
		"[\\}]" => TParenthesis(PtRightCurly, lexer.current),
		"[\\[]" => TParenthesis(PtLeftBracket, lexer.current),
		"[\\]]" => TParenthesis(PtRightBracket, lexer.current),
		"[\\(]" => TParenthesis(PtLeftBracket, lexer.current),
		"[\\)]" => TParenthesis(PtRightBracket, lexer.current),
		"[\\:]" => TOperator(OtColon, lexer.current),
		"[\\.]" => TOperator(OtDot, lexer.current),
		"[,]" => TOperator(OtComma, lexer.current),
		"==" => TOperator(OtEq, lexer.current),
		"=" => TOperator(OtAssign, lexer.current),
		"[\\!]=" => TOperator(OtNotEq, lexer.current),
		"[\\!]" => TOperator(OtNot, lexer.current),
		"[\\~]" => TOperator(OtComplement, lexer.current),
		"[\\+][\\+]" => TOperator(OtPlusPlus, lexer.current),
		"[\\+]=" => TOperator(OtPlusAssign, lexer.current),
		"[\\-][\\-]" => TOperator(OtMinusMinus, lexer.current),
		"[\\-]=" => TOperator(OtMinusAssign, lexer.current),
		"[\\-]" => TOperator(OtMinus, lexer.current),
		"[\\?]" => TOperator(OtQuest, lexer.current),
		"[\\|][\\|]" => TOperator(OtCondOr, lexer.current),
		"[\\|]" => TOperator(OtBitOr, lexer.current),
		"[\\|]=" => TOperator(OtBitOrAssign, lexer.current),
		"&&" => TOperator(OtCondAnd, lexer.current),
		"&=" => TOperator(OtBitAndAssign, lexer.current),
		"&" => TOperator(OtBitAnd, lexer.current),
		"<<=" => TOperator(OtShiftLeftAssign, lexer.current),		
		"<<" => TOperator(OtShiftLeft, lexer.current),		
		";" => TOperator(OtSemi, lexer.current),
		"break" => TKeyword(KtBreak, lexer.current),
		"default" => TKeyword(KtDefault, lexer.current),
		"package" => TKeyword(KtPackage, lexer.current),
		"function" => TKeyword(KtFunction, lexer.current),
		"case" => TKeyword(KtCase, lexer.current),
		"cast" => TKeyword(KtCast, lexer.current),
		"abstract" => TKeyword(KtAbstract, lexer.current),
		"from" => TKeyword(KtFrom, lexer.current),
		"to" => TKeyword(KtTo, lexer.current),
		"class" => TKeyword(KtClass, lexer.current),
		"enum" => TKeyword(KtEnum, lexer.current),
		"interface" => TKeyword(KtInterface, lexer.current),
		"implements" => TKeyword(KtImplements, lexer.current),
		"extends" => TKeyword(KtExtends, lexer.current),
		"null" => TKeyword(KtNull, lexer.current),
		"true" => TKeyword(KtTrue, lexer.current),
		"false" => TKeyword(KtFalse, lexer.current),
		"this" => TKeyword(KtThis, lexer.current),
		"super" => TKeyword(KtSuper, lexer.current),
		"if" => TKeyword(KtIf, lexer.current),
		"for" => TKeyword(KtFor, lexer.current),
		"do" => TKeyword(KtDo, lexer.current),
		"while" => TKeyword(KtWhile, lexer.current),
		"return" => TKeyword(KtReturn, lexer.current),
		"import" => TKeyword(KtImport, lexer.current),
		"using" => TKeyword(KtUsing, lexer.current),
		"continue" => TKeyword(KtContinue, lexer.current),
		"else" => TKeyword(KtElse, lexer.current),
		"switch" => TKeyword(KtSwitch, lexer.current),
		"throw" => TKeyword(KtThrow, lexer.current),
		"var" => TKeyword(KtVar, lexer.current),
		"final" => TKeyword(KtFinal, lexer.current),
		"static" => TKeyword(KtStatic, lexer.current),
		"public" => TKeyword(KtPublic, lexer.current),
		"private" => TKeyword(KtPrivate, lexer.current),
		"dynamic" => TKeyword(KtDynamic, lexer.current),
		"never" => TKeyword(KtNever, lexer.current),
		"override" => TKeyword(KtOverride, lexer.current),
		"inline" => TKeyword(KtInline, lexer.current),
		"macro" => TKeyword(KtMacro, lexer.current),
		"untyped" => TKeyword(KtUntyped, lexer.current),
		"typedef" => TKeyword(KtTypedef, lexer.current),
		"extern" => TKeyword(KtExtern, lexer.current),
		"try" => TKeyword(KtTry, lexer.current),
		"catch" => TKeyword(KtCatch, lexer.current),
		"[\\.][\\*]" => TKeyword(KtWildcard, lexer.current),

    "-?(([1-9][0-9]*)|0)(.[0-9]+)?([eE][\\+\\-]?[0-9]+)?" => TNumber(lexer.current),
    // '[0-9]+' => TNumber(lexer.current),
		'"' => {
			buf = new StringBuf();
			lexer.token(string);
			TString(buf.toString());
		},
		"[A-Za-z_][\\-A-Za-z0-9]+" => TIdentifier(lexer.current),
    "[\r\n\t ]+" => TWspace(lexer.current),
    "" => TEof,
	];

	static var string = @:rule [
		"\\\\t" => {
			buf.addChar("\t".code);
			lexer.token(string);
		},
		"\\\\n" => {
			buf.addChar("\n".code);
			lexer.token(string);
		},
		"\\\\r" => {
			buf.addChar("\r".code);
			lexer.token(string);
		},
		'\\\\"' => {
			buf.addChar('"'.code);
			lexer.token(string);
		},
		"\\\\u[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]" => {
			buf.add(String.fromCharCode(Std.parseInt("0x" +lexer.current.substr(2))));
			lexer.token(string);
		},
		'"' => {
			lexer.curPos().pmax;
		},
		'[^"]' => {
			buf.add(lexer.current);
			lexer.token(string);
		},
	];  
}

class HaxeFile {
	public var packageString: String;
	public function new() {

	}
}

class DudeParser extends hxparse.Parser<hxparse.LexerTokenSource<Token>, Token> {
  public function new(input:byte.ByteData, sourceName:String) {
    var lexer = new DudeLexer(input, sourceName);
    var ts = new hxparse.LexerTokenSource(lexer, DudeLexer.tok);
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

	public function parseHaxeFile(): Dynamic {
		var statement = hxparse.Parser.parse(switch stream {
			case [TNumber(n), s = parseTopLevelList()]:
				{ heading: n, body: s}; // package info
			case [s = parseTopLevelList()]:
				{body: s};
		});

		trace(statement);
		return new HaxeFile();
	}

	public function parseTopLevelList(): Array<Dynamic> {
		var output = [];

		var hasTokens = true;

		var item = null;
		 do {
			 item = hxparse.Parser.parse(switch stream {
				case [s = parseTopLevel()]: 
					s; // package info
				case [TEof]:
					hasTokens = false;
					null;
				});
			
			if (item != null) {
				output.push(item);
			}
		} while(item != null && hasTokens);

		return output;
	}

	public function parseTopLevel(): Dynamic {
		return hxparse.Parser.parse(switch stream {
			case [im = parseImportStatement()]:
				im;
			case [TString(s)]:
				s;
		});
	}

	public function parseImportStatement(): Dynamic {
	//	simpleQualifiedReferenceExpression [importWildcard | importAlias]';'

		return hxparse.Parser.parse(switch stream {
			// import alias ('in' | 'as') identifier
			case [TKeyword(KtImport, _), sqr = parseSimpleQualifiedReferenceExpression(), TOperator(OtSemi, _)]:
				sqr;
		});
	}

	private function parseSimpleQualifiedReferenceExpression(): Dynamic {
		return hxparse.Parser.parse(switch stream {
			case [TIdentifier(id0), items = parseQualifiedReferenceExpression()]:
				id0 + items;
			// case [TIdentifier(id)]:
			// 	{id:id};
			// import alias ('in' | 'as') identifier
			// case [TIdentifier(id), items = parseSimpleQualifiedReferenceExpression()]:
			// 	{id:id, items:items};
			// // import wildcard
		});
	}

	private function parseQualifiedReferenceExpression(): String {
		var result = "";

		var item = null;
		do {
		 	item = hxparse.Parser.parse(switch stream {
				case [TOperator(OtDot, _), TIdentifier(id)]: {
					id;
				}
			});

			if (item != null) {
				result += '.' + item;
			}
		} while(item != null);

		return result;
	}

	// simpleQualifiedReferenceExpression ::= referenceExpression qualifiedReferenceExpression * { elementType="referenceExpression"}
}

class MacroMain {

  public static function main() {
    var path = 'src/foo/MySample.hx';
    var content = sys.io.File.getContent(path);
    var inputData = byte.ByteData.ofString(content);
    // var inputData = byte.ByteData.ofString('12 import() demo.quarter; "hello world" "demo" "hard" "ab"');
    var parser = new DudeParser(inputData, path);
    var text = parser.colorise();
    trace(text);
    // var result = ArithmeticEvaluator.eval(text);
    // if (result != null) {
    //   trace(result);
    // }
  }

}