class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.12.tar.xz"
  sha256 "5f6355b52d9c360619623a40c66c1a5571e393b43fe58375c0de35429ac3480a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "e95b6c6b714ae9ed4d88e084e42ba46b7e86b608cc4a6eac7f9e65a5116fcf92" => :big_sur
    sha256 "749fefcde3a5064b1f9a35d25af6eb1709bd0059bcfa943d043500bf52d276c8" => :arm64_big_sur
    sha256 "c1d09e98b098f34e6552280fa575430faa97456c075708465588ded47b1dfc0b" => :catalina
    sha256 "0ddab1250be82811b51619ace9638303c9576fc32b0b4c3c8b9f19e2cee4ab51" => :mojave
    sha256 "c92742ff97f25590c21b64c2a19ce47dae7b2d1ce405f6d50a3e086ee8eba081" => :high_sierra
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
