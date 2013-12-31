component {
	function run () {
		describe("Dummy test", function () {
			it("runs a test", function () {
				expect(true).toBeTrue();
			});
			it("fails", function () {
				expect(false).toBeTrue();
			});
		});
	}
}