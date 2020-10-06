class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.17.3.tar.gz"
  sha256 "32911a3f7c5e7e83d02007ba53c32f6e5a31957f8f5264c3cb588c0217a868d2"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddebd9aca894d8d78e45288beb3236399ffa6b0707120a8e55f1da652f614148" => :catalina
    sha256 "9d6a5ffbfd5d7a2b4847b2862e43817308697c9314d2918bc8d884c847efbdd9" => :mojave
    sha256 "6849143938b88af4b327bdd7cd356f35132691a8a482232b2bdc2fe9724ae00d" => :high_sierra
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
