class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.20.7.tar.gz"
  sha256 "d73e34e989f458c564138bf1b0238944dea53bc1821ffb4cd470eac91ff865e1"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50fea7f91bd11ddcc3a263e9429eab4a4f7cab478c461ab375556feea7ecede3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edae07f29609ec891b93ee73a8513b4b9f77bb730702a2e5776fe760d200503a"
    sha256 cellar: :any_skip_relocation, monterey:       "1352d3e4ff197ccbb19f558afc9a6f5533d2dc5b5c4db0ea976030501251d65d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fd1b723d118d9535d6bf9a0634916f043552cead63d3b17dd024600f020a10e"
    sha256 cellar: :any_skip_relocation, catalina:       "aaf597d62eacde1e13611c072aa2451fc2162026022bbcb44cef60d2cc79db2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08a47ce0d031dd3e165be0d6de04e380cc819a57835956bb1253c345e610744f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
