class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.io/"
#  if Hardware::CPU.arm? && OS.linux?
#    url "https://git.code.sf.net/p/log4cpp/codegit", using: :git, revision: "2e117d81e94ec4f9c5af42fcf76a0583a036e106"
#    version "1.1.3"
#  else
    url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.3.tar.gz"
    sha256 "2cbbea55a5d6895c9f0116a9a9ce3afb86df383cd05c9d6c1a4238e5e5c8f51d"
#  end
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4cpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/log4cpp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ecea8d0aefaec00c2b8345c5b0708a25ec94f9c6cc4b9723f0b6b4882b5ad44e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fix -flat_namespace being used on Big Sur and later.
#  on_macos do
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
#  end

  def install
#    if Hardware::CPU.arm? && OS.linux?
#      system "autoupdate", "-fv"
#      system "./autogen.sh"
#    end
    Pathname.glob("#{Formula['autoconf'].opt_prefix}/share/autoconf/build-aux/config.*") do |cfg|
      (buildpath/"config").install cfg
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
