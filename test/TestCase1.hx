package test;

import buddy.BuddySuite;

using buddy.Should;

class TestCase1 extends BuddySuite {

	public function new() {
		describe("TestCase1", {
			it("testSuccess", {
				"A".should.be("A");
			});

			it("testFailure", {
				"A".should.be("B");
			});

			it("testError", {
				throw "error";
			});

			it("testEmpty", {});
		});

		describe("TestCase2", {
			it("testSuccess", {
				"A".should.be("A");
			});
		});
	}
}
