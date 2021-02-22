package hxcodecolors;

enum Token {
  TString(v:String);
  TNumber(v:String);
	TIdentifier(v:String);
	TOperator(ot:OperatorTerm, s: String);
	TKeyword(kt:KeywordTerm, s: String);
	TParenthesis(pt:ParenthesisTerm, s:String);
	TWspace(s:String);
  TEof;
}