class Numdiff < Formula
  desc "Putative files comparison tool"
  homepage "https://www.nongnu.org/numdiff"
  url "https://download.savannah.gnu.org/releases/numdiff/numdiff-5.9.0.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/numdiff/numdiff-5.9.0.tar.gz"
  sha256 "87284a117944723eebbf077f857a0a114d818f8b5b54d289d59e73581194f5ef"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/numdiff/"
    regex(/href=.*?numdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/numdiff"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "70363226c4789fb058b0e2e1e92cc8f53c1607f9a1467ce752e4abdc0c8856ca"
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-debug", "--disable-nls", "--enable-gmp",
           "--prefix=#{prefix}", "--libdir=#{lib}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "1 2\n"
    (testpath/"b").write "1.1 2.5\n"

    expected = <<~EOS
      ----------------
      ##1       #:1   <== 1
      ##1       #:1   ==> 1.1
      @ Absolute error = 1.0000000000e-1, Relative error = 1.0000000000e-1
      ##1       #:2   <== 2
      ##1       #:2   ==> 2.5
      @ Absolute error = 5.0000000000e-1, Relative error = 2.5000000000e-1

      +++  File "a" differs from file "b"
    EOS
    assert_equal expected, shell_output("#{bin}/numdiff a b", 1)
  end
end
