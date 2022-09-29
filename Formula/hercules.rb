class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "http://www.hercules-390.eu/"
  url "http://downloads.hercules-390.eu/hercules-3.13.tar.gz"
  sha256 "890c57c558d58708e55828ae299245bd2763318acf53e456a48aac883ecfe67d"
  license "QPL-1.0"

  livecheck do
    url :homepage
    regex(/href=.*?hercules[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hercules"
    sha256 aarch64_linux: "c56fa31cb5120975f977bf39ed3e27c9f18d012a6750abc380dfe78177699a46"
  end

  head do
    url "https://github.com/hercules-390/hyperion.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  skip_clean :la

  def install
    ENV.deparallelize

    if build.head?
      system "./autogen.sh"
    elsif Hardware::CPU.arm?
      system "autoreconf", "-fvi"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=no"
    system "make"
    system "make", "install"
    pkgshare.install "hercules.cnf"
  end

  test do
    (testpath/"test00.ctl").write <<~EOS
      TEST00 3390 10
      TEST.PDS EMPTY CYL 1 0 5 PO FB 80 6080
    EOS
    system "#{bin}/dasdload", "test00.ctl", "test00.ckd"
  end
end
