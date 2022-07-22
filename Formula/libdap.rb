class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://www.opendap.org/pub/source/libdap-3.20.11.tar.gz"
    sha256 "850debf6ee6991350bf31051308093bee35ddd2121e4002be7e130a319de1415"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "92a56dd467c976e0e7fdbd965ce2d290064ea7fafafbf878f039b1afffbbbdee"
    sha256 arm64_big_sur:  "df808c09fe783470f805aa06e12c2a3dcc5c28f5da166734bbdd016d3b86c005"
    sha256 monterey:       "9d154311b1a4faa2daec6194ec2cbd342a33fe57c895e3dffefd33f28f3ca900"
    sha256 big_sur:        "5606181c41261d895ecd7822bac4696a8eda8087b3421841b880929a97d914fc"
    sha256 catalina:       "a548bf56cc425c7180ee6dd851d789f3ac0f51542cb93ecbd9e795a7131d9a39"
    sha256 x86_64_linux:   "4d2f8c5e6fd9a76213d8e051ab4a8b38981ebe212b56411fdfd006fceb9d4de5"
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
