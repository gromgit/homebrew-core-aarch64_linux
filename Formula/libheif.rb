class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.12.0/libheif-1.12.0.tar.gz"
  sha256 "e1ac2abb354fdc8ccdca71363ebad7503ad731c84022cf460837f0839e171718"
  license "LGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "373e6133db16e9627f6f176e031baaf2a988598ca8711d353634aa5c11ef21cf"
    sha256 cellar: :any, arm64_big_sur:  "d1aff6492a744b9ead267d3385e9b32d8342f0128aedc34d88ba32e0a23da32e"
    sha256 cellar: :any, monterey:       "22e2cc8cd29654d6da8aa58b851c30b74fcd30cf440bd57f9b4bdb7b6f99cd8f"
    sha256 cellar: :any, big_sur:        "4aaee988fadc6d0304c3dd0c4136e691c5fb273c27b1a3fe3e3d04cb5336ac7c"
    sha256 cellar: :any, catalina:       "116f5e5f03aead804ff52f2b74606ad0cf6a78875f95bba734cdc0f4ec654cbc"
  end

  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleheic-1.jpg", :exist?
    assert_predicate testpath/"exampleheic-2.jpg", :exist?

    output = "File contains 1 images"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleavif.jpg", :exist?
  end
end
