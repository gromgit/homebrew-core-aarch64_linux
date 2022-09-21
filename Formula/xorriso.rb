class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/xorriso/xorriso-1.5.4.tar.gz"
  sha256 "3ac155f0ca53e8dbeefacc7f32205a98f4f27d2d348de39ee0183ba8a4c9e392"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xorriso"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2b071d1dcfb5fcc3c43535c612a2d59d7d2f353adae2482cc7eed1577eb949e8"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system bin/"xorriso", "--help"
  end
end
