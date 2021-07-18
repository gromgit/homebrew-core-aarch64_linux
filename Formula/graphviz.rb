class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.48.0",
      revision: "0e477c1e151e57c7d1865ed14e6add1c63c0b03a"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 arm64_big_sur: "452ad2a405771fc2d4655d5183f7b3e70520c1cca66c7ccf1567edd8e82a8a11"
    sha256 big_sur:       "36bb031ebbc2080491538c2e3394c8295f7049db86eb3d9c0d6bb550f1bad10c"
    sha256 catalina:      "b320c6481e7cc897ec533d7268b57bd668a079e471a7408b642137229872d12e"
    sha256 mojave:        "0014adcf96e5eff7ede0e08e7b3e045681b03e779c2d5ede2b09dc308050f68c"
    sha256 x86_64_linux:  "cdbcdcbd4d50288bc1c260eb59d35f5f4adfdf9bbb188d1ae171e5992f2d2833"
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

    (bin/"gvmap.sh").unlink
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
