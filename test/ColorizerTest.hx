package;

import buddy.BuddySuite;

using buddy.Should;

using hxcodecolors.Colorizer;

class ColorizerTest extends BuddySuite {
  public function new() {
		describe("ColorizerTest", {
      var colorizer = new Colorizer();

			describe("build(red)", {
        var actual = colorizer.build(['red']);
        it("prefix", {
          actual[0].should.be('\u001B[31m');
        });
        it("suffix", {
          actual[1].should.be('\u001B[39m');
        });
			});

			describe("build(yellow,bold)", {
        var actual = colorizer.build(['yellow', 'bold']);
        it("prefix", {
          actual[0].should.be('\u001B[1m\u001B[33m');
        });
        it("suffix", {
          actual[1].should.be('\u001B[39m\u001B[22m');
        });
			});      
		});
  }
}