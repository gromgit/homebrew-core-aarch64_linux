class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "http://devel.ringlet.net/sysutils/prips/"
  url "http://devel.ringlet.net/sysutils/prips/prips-0.9.9.tar.gz"
  sha256 "ad9d8e63cd69ed682ea87c154a19e5c58a3eb4bb3a118d5f458fd86eadb3bef8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ddb411a412f058c494bb6383e526c5308856ee24155ba287fcc59b3ed8bd6e9" => :el_capitan
    sha256 "ead7a6597e61fa4aa8a6a64bd1602e6d3450c1b78363ca8d3adf8e723cfe4346" => :yosemite
    sha256 "db4780094428ee5ae253ff027585514af39d0edbc393157f364d03efc2b0902b" => :mavericks
  end

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
