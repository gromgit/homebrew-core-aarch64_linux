class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://github.com/xiph/speexdsp"
  url "https://github.com/xiph/speexdsp/archive/SpeexDSP-1.2.1.tar.gz"
  sha256 "d17ca363654556a4ff1d02cc13d9eb1fc5a8642c90b40bd54ce266c3807b91a7"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/speexdsp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7f9752113b5d0bd32747fc04882221a83b5e98b94741c0487e687127587bf5d3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
