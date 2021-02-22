package test;

import haxe.macro.Expr.Var;
using StringTools;

import buddy.BuddySuite.Spec;
import promhx.Promise;
import buddy.SuitesRunner;

using test.TestCase1;
import tests.TestCase3;
using ColorizerTest;

using buddy.reporting.Reporter;
using buddy.BuddySuite.Suite;
import promhx.Deferred;
import haxe.CallStack.StackItem;

import hxcodecolors.Colorizer;

class JestReporter implements Reporter {
	var totalTests: Int = 0;
	var passedTests: Int = 0;
	var failedTests: Int = 0;
	var pendingTests: Int = 0;
	var unknownTests: Int = 0;
	var totalSuites: Int = 0;
	var passedSuites: Int = 0;
	var colorizer: Colorizer;

	public function new () {
		this.totalTests = 0;
		this.passedTests = 0;
		this.failedTests = 0;
		this.pendingTests = 0;
		this.unknownTests = 0;
		this.passedSuites = 0;
		this.totalSuites = 0;
		this.colorizer = new Colorizer();
	}

	/**
	 * Convenience method.
	 */
	 private function resolveImmediately<T>(o : T) : Promise<T> {
		var def = new Deferred<T>();
		var pr = def.promise();
		def.resolve(o);
		return pr;
	}

	function countSuite(_suite : Suite) {
		this.totalSuites += 1;
		if (_suite.passed()) {
			this.passedSuites++;
		}

		for (step in _suite.steps) {
			switch (step) {
				case TSpec(step):
						totalTests++;

						switch (step.status) {
								case Unknown: unknownTests++;
								case Passed : passedTests++;
								case Pending: pendingTests++;
								case Failed : failedTests++;
						}

				case TSuite(step):
					countSuite(step);
			}
		}
	}

	static function printMsg(line: String) {
		Sys.print(line);
	}

	static function printMsgLine(line: String) {
		Sys.println(line);
	}

	static function printTraces(spec : Spec) {
		for (t in spec.traces) printMsgLine("    " + t);
	}

	static function isNotInternalFile(file :String):Bool {
		for(pattern in ["buddy/internal/", "buddy.SuitesRunner", "buddy/SuitesRunner"]) {
			if (file.indexOf(pattern) >= 0) {
				return false;
			}
		}
		return true;
	}

	function printStack(indent : String, stack: Array<StackItem>) {
		if (stack == null || stack.length == 0) return;
		for (s in stack) switch s {
			case FilePos(_, file, line) if (isNotInternalFile(file)):
				printMsgLine(indent + '@ $file:$line');
			case _:
		}
	}

	function printTests(level: Int, suite: Suite, parentDescription: String) {
		// if (suite.description.length > 0) {
		// 	printMsgLine(suite.description);
		// }

		var success = true;
		for (step in suite.steps) switch step {
			case TSpec(sp):
				success = success && sp.status == Passed;

				if (sp.status == Failed) {
					var failedStyle = this.colorizer.build(['red', 'inverse']);
					var pathStyle = this.colorizer.build(['red', 'bold', 'dim']);
					var fileStyle = this.colorizer.build(['bold']);
					var path = new haxe.io.Path(sp.fileName);

					printMsgLine(failedStyle[0] + ' FAIL ' + failedStyle[1] + ' ' + pathStyle[0] + path.dir + '/' + pathStyle[1] + fileStyle[0] + path.file + '.' + path.ext + fileStyle[1]);

					var descriptionStyle = this.colorizer.build(['redBright', 'bold']);
					printMsgLine(descriptionStyle[0] + '  \u25cf ' + parentDescription + sp.description + descriptionStyle[1]);
					printTraces(sp);

					for(failure in sp.failures) {
						printMsgLine("    " + failure.error); // YELLO
						printStack('      ', failure.stack);
					}
				}
				// else {
				// 	printMsgLine("  " + sp.description + " (" + sp.status + ")");
				// 	printTraces(sp);
				// }
			case TSuite(s):
				var joiner = ((level >= 2) ? ' > ' : '');
				var parentDescription = parentDescription + joiner + suite.description;
				printTests(level + 1, s, parentDescription);
		}
	}

	public function done(suites : Iterable<Suite>, status : Bool) : Promise<Iterable<Suite>> {
		for(suite in suites) {
			printTests(-1, suite, '');
			countSuite(suite);
		}

		var displaySuiteStats = () -> {
			var boldStyle = this.colorizer.build(['bold']);
			Sys.print(boldStyle[0] + 'Test Suites: ' + boldStyle[1]);
			
			var failedSuites = this.totalSuites - this.passedSuites;
			if (failedSuites > 0) {
				var failedStyle = this.colorizer.build(['red','bold']);
				Sys.print(failedStyle[0] + '${failedSuites} failed' + failedStyle[1] + ', ');
			}
			// TODO: pending
			if (this.passedSuites > 0) {
				var failedStyle = this.colorizer.build(['green', 'bold']);
				Sys.print(failedStyle[0] + '${this.passedSuites} passed' + failedStyle[1] + ', ');
			}

			Sys.println('${failedSuites} of ${this.totalSuites} total');
		}

		var displayTestStats = () -> {
			var boldStyle = this.colorizer.build(['bold']);
			printMsg(boldStyle[0] + 'Tests:       ' + boldStyle[1]);

			if (this.failedTests > 0) {
				var failedStyle = this.colorizer.build(['bold', 'red']);
				printMsg(failedStyle[0] + '${this.failedTests} failed' + failedStyle[1] + ', ');
			}
			if (this.pendingTests > 0) {
				var pendingStyle = this.colorizer.build(['yellow', 'bold']);
				printMsg(pendingStyle[0] + '${this.pendingTests} skipped' + pendingStyle[1]+ ', ');
			}
			if (this.unknownTests > 0) {
				var unknownStyle = this.colorizer.build(['magenta', 'bold']);
				printMsg(unknownStyle[0] +'${this.unknownTests} status unknown' + unknownStyle[1] + ', ');
			}
			if (this.passedTests > 0) {
				var passedStyle = this.colorizer.build(['green', 'bold']);
				printMsg(passedStyle[0]+ '${this.passedTests} passed' + passedStyle[1] + ', ');
			}
			printMsgLine('${this.totalTests} total');
		}

		displaySuiteStats();
		displayTestStats();

		// Sys.println('success: ${status}');
		return resolveImmediately(suites);
	}

	public function progress(spec:Spec):Promise<Spec> {
		return resolveImmediately(spec);
	}

	public function start():Promise<Bool> {
		return resolveImmediately(true);
	}
}

class JestRunner {
	public static function main() {
		var reporter = new JestReporter();

		new SuitesRunner([
			new TestCase1(),
			new TestCase3(),
			new test.TestCase4(),
			new ColorizerTest()
		], reporter).run();
	}
}
