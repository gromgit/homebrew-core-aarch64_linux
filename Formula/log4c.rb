class Log4c < Formula
  desc "Logging Framework for C"
  homepage "https://log4c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4c/log4c/1.2.4/log4c-1.2.4.tar.gz"
  sha256 "5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea"
  license "LGPL-2.1"
  head "https://git.code.sf.net/p/log4c/log4c.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4c[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/log4c"
    sha256 aarch64_linux: "5d5a68b6de762ff77a1895ae8563ab8fe2d20edf183b158e46ff81cb6d9b52aa"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/log4c-config", "--version"
  end
end
