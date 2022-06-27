class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga4-src.tgz"
  sha256 "6a89ebdc7817bc204f79ebcdc6b5e7fef8c19aedfbc80284fedc647caa086790"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9fe02074120054f04485370f2a816f0e52054e9a4c5bda381502e0e21b8a3ee6"
    sha256 arm64_big_sur:  "13160d0ed0dc57346e31eb90da29faf9f422fb5244f1814ed154ed38e55fddd1"
    sha256 monterey:       "7c8819a4a3b755ea498659d2d2018efafe39f7260d2f64f73176713bbca8a798"
    sha256 big_sur:        "d05fb07ad9a4f8f023ae193d3cd00360b3d58389f577cd56a93f2a2dbae9aacb"
    sha256 catalina:       "f232bc8bc2bc19197b8264a7fad89bc665ddfbbe17620b0ec18807bb7830b9bb"
    sha256 x86_64_linux:   "dcfb7ca551686db85085601aafa03f09fbb2ae3a524993491c026a65e5295be4"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  # Apply patch on 4.2ga4. Remove after next release
  # https://github.com/pmattes/x3270/issues/36
  patch do
    url "https://github.com/pmattes/x3270/commit/80168fbc69544fee00517fb5b14bc662501929b8.patch?full_index=1"
    sha256 "a1a00c9396e565879e3cb5ff230861c914ebdf82e44911dd2799c43e2e2ccfad"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
