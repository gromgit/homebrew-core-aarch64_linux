class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.3.tar.gz"
  sha256 "2cbbea55a5d6895c9f0116a9a9ce3afb86df383cd05c9d6c1a4238e5e5c8f51d"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4cpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/log4cpp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2c4ef0f1ec6baadc9368a9e79386a27d21b65956466ea8a7fb6c1529338aa59e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    cp Dir["#{Formula["libtool"].opt_pkgshare}/*/config.{guess,sub}"], buildpath/"config"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
