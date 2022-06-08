class Pk < Formula
  desc "Field extractor command-line utility"
  homepage "https://github.com/johnmorrow/pk"
  url "https://github.com/johnmorrow/pk/releases/download/v1.0.2/pk-1.0.2.tar.gz"
  sha256 "0431fe8fcbdfb3ac8ccfdef3d098d6397556f8905b7dec21bc15942a8fc5f110"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "62319902a18c0fddca211a42c1efd49ff533946d8b92c1f15c5dc872754b358f"
  end

  on_macos do
    depends_on "argp-standalone"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    assert_equal "B C D", pipe_output("#{bin}/pk 2..4", "A B C D E", 0).chomp
  end
end
