class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.1.tar.gz"
  sha256 "1d142f4e0b9d490d6d7bc495dc57b8c322895b0e6ec474d04d5f6910d61e5476"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "9f9d6f343dc0a7e6ecf34a27e97049b62952e5a05319b1f7aa4c235cf793fc5e" => :catalina
    sha256 "cf48ec533b5cc0db3cf56903091936822c422d484371c28b2397bd02bd3bdbbb" => :mojave
    sha256 "5999a97a256941d082e171faceb5cbf7fb54720031d71cc1c086d8d08d18ff01" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libgsf"
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    system "./autogen.sh"
    system "./configure", "--with-gsf", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version", 255)
  end
end
