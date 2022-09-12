class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.22.1.tar.gz"
  sha256 "f28b50a7bdc4d8b5b42e0e1bfe3211f8c1b51cd8ced204977c415f60e01f916c"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "061faf51f8fd8f69f43fa06902a604c3b4ef465dca593c6da6b6545ddbc80d85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40ea3b2a3bc35dea67a5541ece82bc4e73fb9e8360c95d02d4f1c57900ad01b3"
    sha256 cellar: :any_skip_relocation, monterey:       "75b16c1b84b67f9e2bb1a68a9f98bb7834fb06f3e24b5372299c3bda37b7c96a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0eaa87d48cbfb9fcc1fe0d658385cfad9d2c23ab55c105549fd58d36e90a62e"
    sha256 cellar: :any_skip_relocation, catalina:       "14fa3156be842b46717975e721745034d0226da11522f43ea09815fb4f5d5994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21550c583c639f11b818a7073cabf5d68e74c4b725b13d2c9eaa6b8ed8212fd2"
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
