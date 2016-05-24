require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "http://www.cryptol.net/"
  url "https://github.com/GaloisInc/cryptol.git",
      :tag => "2.3.0",
      :revision => "eb51fab238797dfc10274fd60c68acd4bdf53820"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    revision 1
    sha256 "029b27a757693e94ecc6a5edf73686577dcdb258cfe1e6544a9d6764c0c7e2da" => :el_capitan
    sha256 "f6189a54a06fb8a7e91b1526cdb1b02cd0b5c0638421a7bcfbbcd12bf6aceb2b" => :yosemite
    sha256 "f29fb9813f77732f71a1d9e78fc5615f97b15847b894453afe4bd746a17befc5" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3"

  def install
    cabal_sandbox do
      system "make", "PREFIX=#{prefix}", "install"
    end
  end

  test do
    (testpath/"helloworld.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    result = shell_output "#{bin}/cryptol -b #{(testpath/"helloworld.icry")}"
    expected = <<-EOS.undent
      Loading module Cryptol
      Q.E.D.
      Q.E.D.
    EOS
    assert_match expected, result
  end
end
