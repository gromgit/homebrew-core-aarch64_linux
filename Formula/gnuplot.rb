class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.2.8/gnuplot-5.2.8.tar.gz"
  sha256 "60a6764ccf404a1668c140f11cc1f699290ab70daa1151bb58fed6139a28ac37"

  bottle do
    sha256 "e1da5191c494e45bc6b899baa87094d588bbd659abf348d91341480be02eea05" => :catalina
    sha256 "c5f7eb8ca16ddc90c9c14f100c43c46c5be179dc1389bf85e1d7726dd862c6d7" => :mojave
    sha256 "4f09ccc4c4bf56c65873e20f7265df44fcbec3e319592a2d6870ee3a06a60dfa" => :high_sierra
    sha256 "33c03c8bff2e427d6c2b25575de43b8c41041919b79c320b1a57a8de23cb5d7d" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt"
  depends_on "readline"

  def install
    # Qt5 requires c++11 (and the other backends do not care)
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-tutorial
      --disable-wxwidgets
      --with-qt
      --without-x
    ]

    system "./prepare" if build.head?
    system "./configure", *args
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end
