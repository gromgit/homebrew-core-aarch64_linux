class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.49.3",
      revision: "3425dae078262591d04fec107ec71ab010651852"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "6b66e92e9f9e1abee4ea21839bb137f9754526994c41dcd952f5b15bfcd4c386"
    sha256 monterey:      "1a2fb506d039b671ac4b7502db53a647d215b7c0515215703e70648e485a7528"
    sha256 big_sur:       "cfb8c0621bd74e2517b66ab3df6845feec5bf9468ec18274924ce3bccb15f3ce"
    sha256 catalina:      "bd8cd2241e0e4dd5c763093852628c16c7d0fac5929592e1f46c208587e71bb6"
    sha256 x86_64_linux:  "e311e8fba55dd28e22e12ed2635c9aa1f5ee4c725884337d15b2ca9da47e38f1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "byacc" => :build
    depends_on "ghostscript" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --disable-tcl
      --with-quartz
      --without-freetype2
      --without-gdk
      --without-gdk-pixbuf
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-gts
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
