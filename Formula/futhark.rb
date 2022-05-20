class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.12.tar.gz"
  sha256 "b5610709339885954fd8bb9f67bfc69fbebead9a573380bdabce7c425b23697c"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "087b5981a32590aee5202741cc8d015e423c1278d83b89c36dac52eb2d23b3c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab24b601b3280e22066d54482a2f4670232b0a80845104fddc42c25554db6c35"
    sha256 cellar: :any_skip_relocation, monterey:       "53c7766716e659d3e33564a90ff250c5c960104830c7aa24227c128ce10d8a9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea9d516c76b9b8442515efbccc11de98aaa0a668f4a2c162c22d103ac13e82f8"
    sha256 cellar: :any_skip_relocation, catalina:       "647bcccf0bf6822f11295a4c64d9a3964ccce3668819ea22f30358e03cef0ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9070af75d216ce98f66a35cbe49ed322f7410f730e2f9da449a44a0f2d4d77da"
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
