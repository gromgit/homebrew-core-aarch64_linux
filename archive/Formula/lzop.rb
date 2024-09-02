class Lzop < Formula
  desc "File compressor"
  homepage "https://www.lzop.org/"
  url "https://www.lzop.org/download/lzop-1.04.tar.gz"
  sha256 "7e72b62a8a60aff5200a047eea0773a8fb205caf7acbe1774d95147f305a2f41"
  license "GPL-2.0"

  livecheck do
    url "https://www.lzop.org/download/"
    regex(/href=.*?lzop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lzop"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2fd59d315a2396a469bc48089e1623f395fd24e29de6aa58bcd413a77fc01585"
  end

  depends_on "lzo"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"test"
    text = "This is Homebrew"
    path.write text

    system "#{bin}/lzop", "test"
    assert_predicate testpath/"test.lzo", :exist?
    rm path

    system "#{bin}/lzop", "-d", "test.lzo"
    assert_equal text, path.read
  end
end
