class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.8.tar.xz"
  sha256 "13e97f8d1828f70c09ccdaab6c8dc7bebefaf5e28fc4afa4faf1bb80030e4805"

  bottle do
    sha256 "e2ccab956275d5eaf61ef8ec2645ccde0cfbfe3e84d59b42d86a29f0b565064b" => :catalina
    sha256 "7d131da5c86b9dd7ed471cea85343de18ef20a7d7d4bf653fe433e801d817a54" => :mojave
    sha256 "7f5fcd50154d66822876400e074918e31672585d046ec8a12907e9c4c8eb1b84" => :high_sierra
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
