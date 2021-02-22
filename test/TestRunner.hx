package test;

import buddy.SuitesRunner;

using test.TestCase1;
import tests.TestCase3;
using ColorizerTest;

class TestRunner {
	public static function main() {
		var reporter = new buddy.reporting.ConsoleColorReporter();

		new SuitesRunner([
			new TestCase1(),
			new TestCase3(),
			new test.TestCase4(),
			new ColorizerTest()
		], reporter).run();
	}
}
