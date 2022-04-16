class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.9.tar.gz"
  sha256 "f7409980f86ab5cdef630977a8914a0470a162e372527366c4e139af4027611c"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112e2b68855b8b754a83efef330deb8017e0b438887f31b429315b0e0f324ba7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "651af43669f8b9bdf2f26a1d73398098142ebfc4243862c59a3feadece11af5a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a9a31349047898faf6f1ce088f2cd7623085970767e784ad79df5ff2ad2c853"
    sha256 cellar: :any_skip_relocation, big_sur:        "d651e41f5abe0e5581c9e71b19e534560e882664e5b529118ea989e1f2ed7912"
    sha256 cellar: :any_skip_relocation, catalina:       "039906a922737aed3e3fa7950f9f9f4706dceb19de70e8071de27666b6ae8f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bda66b7f948068aa193545a3546dae3fef1616ccfb7f2a2cd5c794a625ea1e28"
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
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
