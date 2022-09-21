class Xhyve < Formula
  desc "Lightweight macOS virtualization solution based on FreeBSD's bhyve"
  homepage "https://github.com/machyve/xhyve"
  url "https://github.com/machyve/xhyve/archive/v0.2.0.tar.gz"
  sha256 "32c390529a73c8eb33dbc1aede7baab5100c314f726cac14627d2204ad9d3b3c"
  head "https://github.com/machyve/xhyve.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  def install
    args = []
    args << "GIT_VERSION=#{version}" if build.stable?
    system "make", *args
    bin.install "build/xhyve"
    pkgshare.install "test/"
    pkgshare.install Dir["xhyverun*.sh"]
    man1.install "xhyve.1" if build.head?
  end

  test do
    system "#{bin}/xhyve", "-v"
  end
end
