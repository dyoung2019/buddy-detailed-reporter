package test;

import foo.MySample;
import buddy.BuddySuite;

using buddy.Should;

class TestCase4 extends BuddySuite {
	public function new() {
    var msg = MySample.getMessage();

    describe("TestCase4", {
			it("static function reference class in src folder", {
        msg.should.be("hello world");
      });
    });

	}
}
