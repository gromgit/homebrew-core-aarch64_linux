class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.5.0.tar.gz"
  sha256 "d705e7040e87c3835e54f5602724c400170cdc2c22281deec15f2f7deb5842c1"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00ac6035ebeaf065c1983e2075b909d3da771aef0a1971323eab5cfe633f7496" => :catalina
    sha256 "c96d99b2af2b8a2360df2c76b55cd21c44354be0414cb5355df9e16606d115ae" => :mojave
    sha256 "5cfceacabce06b523f7d4338814b095fda105ad9c667ad8696967e37e0b64335" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
