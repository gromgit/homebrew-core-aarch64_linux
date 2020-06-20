class Wslay < Formula
  desc "C websocket library"
  homepage "https://wslay.sourceforge.io/"
  url "https://github.com/tatsuhiro-t/wslay/releases/download/release-1.1.1/wslay-1.1.1.tar.xz"
  sha256 "166cfa9e3971f868470057ed924ae1b53f428db061b361b9a17c0508719d2cb5"

  bottle do
    cellar :any
    sha256 "e8c9abc264375e73eaf4cf29267ad8f9cddcd92649d0bafe5543da73eae1f26c" => :catalina
    sha256 "abebf8b1210e19530f0446ce3b2e873bc2f960d259ad5a4b9a930c1f4221969e" => :mojave
    sha256 "f2537bdaf7a5fd083e21f034fc6fb18ffe36f7dc16b589b8ef1a29cfbfd58286" => :high_sierra
    sha256 "004c25402d835de2c7c067ee04f64c7cc84207f47483f2b1fcbbcd8c2e3f3a59" => :sierra
    sha256 "518238850151cd6a73a2ac1896b671105bf6160ce043ba2afbe62b71816267b2" => :el_capitan
  end

  head do
    url "https://github.com/tatsuhiro-t/wslay.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "check"
    system "make", "install"
  end
end
