class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.12.tar.xz"
  sha256 "5f6355b52d9c360619623a40c66c1a5571e393b43fe58375c0de35429ac3480a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "77c41a741e2a15b06cbcdb58f662ce5766b0e54f65bd096b0bceb5eab3ce3420" => :big_sur
    sha256 "7cfa5ab2e69e875b11145a0ad3bfe4a372b522cb5ecb8d81738f67e619aa5eeb" => :catalina
    sha256 "58689c559173e5e3a15cdffbd055f4a6466ebcba2278d1492a26e86cc19ce244" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
