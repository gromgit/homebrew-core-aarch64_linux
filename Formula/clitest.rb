class Clitest < Formula
  desc "Command-Line Tester"
  homepage "https://github.com/aureliojargas/clitest"
  url "https://github.com/aureliojargas/clitest/archive/refs/tags/0.4.0.tar.gz"
  sha256 "e889fb1fdaae44f0911461cc74849ffefb1fef9b200584e1749b355e4f9a3997"
  license "MIT"
  head "https://github.com/aureliojargas/clitest.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/clitest"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "acc712c52407f9a352b1d3ee3d7e30a0b932a88ec3ec03c18c83e5719e55128c"
  end

  def install
    bin.install "clitest"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      $ echo "Hello World"   #=> Hello World
      $ cd /tmp
      $ pwd                  #=> /tmp
      $ cd "$OLDPWD"
      $
    EOS
    assert_match "OK: 4 of 4 tests passed",
      shell_output("#{bin}/clitest #{testpath}/test.txt")
  end
end
