class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/0.7.0.tar.gz"
  sha256 "bd0873e088701eecdcf6eeb254eed7a4dbe3dd71728e272505c1b8f92c3eebe9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git"

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match(/Total\.*1\n.*Successful\.*1\n/, output)
  end
end
