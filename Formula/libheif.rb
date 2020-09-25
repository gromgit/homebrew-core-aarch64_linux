class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.9.1/libheif-1.9.1.tar.gz"
  sha256 "5f65ca2bd2510eed4e13bdca123131c64067e9dd809213d7aef4dc5e37948bca"
  license "LGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "9c0478e654c5c7da8dd014f9ac33ce0a11e47e5387e29f93d4f479a31c88c537" => :catalina
    sha256 "482935bb3d124f89b03a3127d7fe2f5efa194b0ceb956751307c2aa7584d678f" => :mojave
    sha256 "8989630a939edf69650c13089b33f6cdfb56346684a41d549fad39ea324d54c8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples/example.heic"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"example.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"example-1.jpg", :exist?
    assert_predicate testpath/"example-2.jpg", :exist?
  end
end
