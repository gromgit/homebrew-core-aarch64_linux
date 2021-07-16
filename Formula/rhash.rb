class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.2/rhash-1.4.2-src.tar.gz"
  sha256 "600d00f5f91ef04194d50903d3c79412099328c42f28ff43a0bdb777b00bec62"
  license "0BSD"
  head "https://github.com/rhash/RHash.git"

  bottle do
    sha256 arm64_big_sur: "8eb637a12522739222253513a13aa3fafdc9ab586987f5648290349543017aca"
    sha256 big_sur:       "6f7648fc30e68060747fb9be6480be57c7b30680e429b619f34ead13b9cc80d6"
    sha256 catalina:      "108986af36d715a05223344f3f338c04b0ce5aa6d6cf0c26776be015adaef36a"
    sha256 mojave:        "87ac3199498088f7d465dafefc6f014e10b4692ed3997895bbf1eb288dce8cdd"
  end

  # configure: fix clang detection on macOS
  # Patch accepted and merged upstream, remove on next release
  patch do
    url "https://github.com/rhash/RHash/commit/4dc506066cf1727b021e6352535a8bb315c3f8dc.patch?full_index=1"
    sha256 "3fbfe4603d2ec5228fd198fc87ff3ee281e1f68d252c1afceaa15cba76e9b6b4"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gettext"
    system "make"
    system "make", "install"
    lib.install "librhash/#{shared_library("librhash")}"
    system "make", "-C", "librhash", "install-lib-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end
