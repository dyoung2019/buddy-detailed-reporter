package hxcodecolors;

import hxcodecolors.Token;

class SimplifiedLexer extends hxparse.Lexer implements hxparse.RuleBuilder {
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
		"[\\+]" => TOperator(OtPlus, lexer.current),
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