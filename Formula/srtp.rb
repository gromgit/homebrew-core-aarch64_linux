class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol (SRTP)"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.0.0.tar.gz"
  sha256 "2296d132fd8cadd691d1fffeabbc1b9c42ec09e9e780a0d9bd8234a98e63a5a1"
  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    revision 1
    sha256 "d5f214f13d8c34c39241cd68cb201f72a4fbb493e6a8694d965b2f86b30b8015" => :el_capitan
    sha256 "7a9ac7216782ef2ff6e351705a627eaf535c412fb668086868ab86e5a8334413" => :yosemite
    sha256 "28561181099811365178f954b2938c7921dfcd5cdbf2e5129dbf4ae3fb15b910" => :mavericks
    sha256 "bc26d7076d2cb0c219ab498e2760153ed22b6703be69a5120c114be9d8e5ee2a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :optional

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
    ]
    args << "--enable-openssl" if build.with? "openssl"

    system "./configure", *args
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
