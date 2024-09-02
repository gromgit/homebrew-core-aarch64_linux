class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  url "http://download.augeas.net/augeas-1.12.0.tar.gz"
  sha256 "321942c9cc32185e2e9cb72d0a70eea106635b50269075aca6714e3ec282cb87"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url "http://download.augeas.net/"
    regex(/href=.*?augeas[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/augeas"
    sha256 aarch64_linux: "c8683e7d2ba6cdc6f61639a2b13c5767db78fda8979dd128410e1f945bef8915"
  end


  head do
    url "https://github.com/hercules-team/augeas.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      # autoreconf is needed to work around
      # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44605.
      system "autoreconf", "--force", "--install"
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats
    <<~EOS
      Lenses have been installed to:
        #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
