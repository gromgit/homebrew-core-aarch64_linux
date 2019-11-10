class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0_5_0.tar.gz"
  sha256 "46c9c0ba95c464c70c8a4c099962873e5baa1b9bee3413645a0cc245701047da"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90143853b7f07f54c48a4c577f67f0b3cfa3f91c4fdeed608ff0a386b26b2e77" => :catalina
    sha256 "b0f9b88805d674fa9b672d910947fac7bc4d5390fa2e6c30c85434342123edcf" => :mojave
    sha256 "68a5a897e51a62379501aba204d446f11585db219b001049f4bd9b7359ca6968" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "rust"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> CTRL-D\n", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')

    # Remove the test below and return to the better one above if/when Nushell
    # reinstates the expected behavior for Ctrl+D (EOF)
    assert_match version.to_s, shell_output("#{bin}/nu --version")
  end
end
