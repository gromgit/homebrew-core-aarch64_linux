class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.4.2.tar.gz"
  sha256 "3b1bcb14ebda572b04b9bdf07574a449c84cb924905414e4d94e62837d22b628"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/srtp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1c6ee7f50a31f2fedea2ff89159c99d019bae17ed7ff1c6b0ca85a24f75e7e92"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--enable-openssl"
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
