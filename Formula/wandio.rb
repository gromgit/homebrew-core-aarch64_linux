class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-4.2.3.tar.gz"
  sha256 "78c781ce2c3783b85d894e29005b7e98fc246b33f94616047de3bb4d11d4d823"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?wandio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wandio"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4f1048e22f1581b8042b54925d0a8b378726bc3bfa7306c2b9de58f8061e3d0b"
  end

  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz" # For LZMA
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-z", "9", "-Z", "gzip", "-o", "test.gz",
      test_fixtures("test.png"), test_fixtures("test.pdf")
    assert_predicate testpath/"test.gz", :exist?
  end
end
