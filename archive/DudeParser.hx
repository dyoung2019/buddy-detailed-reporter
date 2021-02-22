
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