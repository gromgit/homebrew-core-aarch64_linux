class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.7.2.tar.gz"
  sha256 "c7640e8232f65ac208b0a0bc21d9b4b695087a3de96e94dd23c47bd37650b884"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e80eaf10dfa5b1bc6d3593d34020f48deb0e4d2df88c7ba828cd9eb2da29f76" => :big_sur
    sha256 "78556d9bd5b9dc1e08f3848b1488f375e85029f3222979476b71fffa95c7528b" => :arm64_big_sur
    sha256 "8b1f02d6c68eb9b67420f7d2b9c1b1ca205b15a54d3fc6d7c5764f6dbc1b512c" => :catalina
    sha256 "c14e28b195ed1d2e7cd4a87be420a52f5619ddb6741c58c9273a3c1a2060f453" => :mojave
  end

  depends_on "rust" => :build

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
