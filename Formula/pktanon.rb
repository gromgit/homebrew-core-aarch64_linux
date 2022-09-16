class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  revision 4

  # The regex below matches development versions, as a stable version isn't yet
  # available. If stable versions appear in the future, we should modify the
  # regex to omit development versions (i.e., remove `(?:[._-]dev)?`).
  livecheck do
    url "https://www.tm.uka.de/software/pktanon/download/index.html"
    regex(/href=.*?pktanon[._-]v?(\d+(?:\.\d+)+)(?:[._-]dev)?\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9a0a99c0307d31a24651f38f7783520a46dab6a73f719f2a339b5fed88909165"
    sha256 cellar: :any,                 arm64_big_sur:  "af5eecdb727ede2277c315672e49eaa7917348847738cb1f3eb916de0a1b846b"
    sha256 cellar: :any,                 monterey:       "652bc79b5cf95d708340ea863e1e7d07667c7872120f54b583e0f4bee21a1c9e"
    sha256 cellar: :any,                 big_sur:        "60234e81604a908d379bc57e162e7f1a4540f088ade8eef94255ece3f85af6a3"
    sha256 cellar: :any,                 catalina:       "4356e0c9f88666d9ac4d9f61afb413f816615cf8f4ec387b9aa34b33347de866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ecb07eba671e414b6e6c1d874b3dca78dde3454ad738359cf099e844d21988"
  end

  depends_on "boost"
  depends_on "xerces-c"

  fails_with gcc: "5"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %Q(#include "Timer.h"\r\n),
      %Q(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pktanon", "--version"
  end
end
