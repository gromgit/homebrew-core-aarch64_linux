class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.15.tar.gz"
  sha256 "2fc96896f66be208708b0a671b82b37cb52337312f23bdb8ef8da6160d0a5c3c"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cfdd8a00c8dea52624779735bdb694a7f98151a018598d9fd6942f098fa83ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb55e3f65b63fc5e784dc0626d176b23625a858f2081f3e8dd68bc02ac28c78a"
    sha256 cellar: :any_skip_relocation, monterey:       "f387a2b565ef6b9a81356e6e16b992b3a51bb6cbbccdd4379f45c305812c659f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b644d77006777e4ca5408bbd3406668a50ca5a7a998eb6adc282f7150de927ef"
    sha256 cellar: :any_skip_relocation, catalina:       "8894ead8b0eead55c844ba12ef9431d693f90004157660dd954c77c731093075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d966ac7e28b80c8936fb4c21c0bb9afbf502b2d58f23282c57d08ce7d5bb95f2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9" => :build
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
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
