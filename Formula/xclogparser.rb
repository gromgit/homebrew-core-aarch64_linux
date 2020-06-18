class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/0.2.15.tar.gz"
  sha256 "152453bd5eb47bcc939f7aade41a3687224e5819b8cc701e05647564391453cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "98529c5425fd844635ae0e6eeb0dcdb1a1421ad777464fc0066cbec7aea6f5e5" => :catalina
    sha256 "0ba85ee25bfdc21ed85615798feed1cf4bd968ad4d8040b8c6751e32fac9804b" => :mojave
  end

  depends_on :xcode => "11.0"

  resource "test_log" do
    url "https://github.com/tinder-maxwellelliott/XCLogParser/releases/download/0.2.9/test.xcactivitylog"
    sha256 "bfcad64404f86340b13524362c1b71ef8ac906ba230bdf074514b96475dd5dca"
  end

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclogparser"
  end

  test do
    resource("test_log").stage(testpath)
    shell_output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    match_data = shell_output.match(/"title" : "(Run custom shell script 'Run Script')"/)
    assert_equal "Run custom shell script 'Run Script'", match_data[1]
  end
end
