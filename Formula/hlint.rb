class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.3.3/hlint-3.3.3.tar.gz"
  sha256 "5f010525aa145bd4a9116abf4b71dd1d42db09de1cb8146418af83a5032132c9"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "abccf934281632959cc607b7eead3b7e94f77471a91579c2ecc2120de6e4dacd"
    sha256 cellar: :any_skip_relocation, big_sur:       "763c691b73fe27b7e603a51a76f435c4c01b4371196b9d2818403ac0112749eb"
    sha256 cellar: :any_skip_relocation, catalina:      "cba4574741af09e99545e68d8829e4cbea9817c85c136ae9988c698e52304652"
    sha256 cellar: :any_skip_relocation, mojave:        "430cde88932cd7701c137f2849e40fbb9be2d62dd07d6b5a4346b1ff442e34a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8984880b76239cd579ddce02bafe5c40faf5aac7511c24def7c86654c1fde95c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "No hints", shell_output("#{bin}/hlint test.hs")

    (testpath/"test1.hs").write <<~EOS
      main = do foo x; return 3; bar z
    EOS
    assert_match "Redundant return", shell_output("#{bin}/hlint test1.hs", 1)
  end
end
