class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.10.0/libheif-1.10.0.tar.gz"
  sha256 "ad5af1276f341277dc537b0d19a4193e0833c247b2aacb936e0c5494141533ae"
  license "LGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "31fda849d5d3ffa475c1ff312cf76c307a639905134f305069f12d0255ec2a4d" => :big_sur
    sha256 "4e6759dcfcedf91ca277b8c338f25f39884b2daacf997f14c9a82e8914cf9a9f" => :catalina
    sha256 "39b1616553af121c49bafcbaf95a19fbdd6dc7ebcecbdfbe3c25dbbc097d2266" => :mojave
    sha256 "18febe31fe9dfa094c745e7e3a45082bbf8c43d928891f7a1856a64ae35a89c6" => :high_sierra
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
