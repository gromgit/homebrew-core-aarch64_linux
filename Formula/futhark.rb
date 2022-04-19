class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.21.10.tar.gz"
  sha256 "c2662b8389dedfa4e1181cd07febb7df042a9c9c756bb2caa26c57b599e123ba"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be4f436e1562bf9c1b2ec4bdcd0b90773b4c1282d39d6bfdce96f860532dd71e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4642d9c31ba187aa6afd01aaed377e2ebd9a559b6c76c65bc6e97917d85d72c3"
    sha256 cellar: :any_skip_relocation, monterey:       "439d36baad1949698e4669d904146069b7a652d95ca941088b4184543d0f9205"
    sha256 cellar: :any_skip_relocation, big_sur:        "b29950e267c2c168fbaf7c7d7876a112260722e4b5ea866e50660d3e0b8485da"
    sha256 cellar: :any_skip_relocation, catalina:       "e91e0c922b7c56a3ef647be9ee0d3c0f7d7f7d6206370820abf228adb145489d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de9fac73e2dec8ddeeb75b47c574b4c8b2ee54540d18d602c9a290cee1488c1d"
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
