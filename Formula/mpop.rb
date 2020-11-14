class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.11.tar.xz"
  sha256 "9b53df519d47b5e709aa066b54b97f0cdca84a06c92dbcf52118f86223dc9dbd"
  license "GPL-3.0"

  bottle do
    sha256 "4d62437fccd5d773e888126e465f1cea07fdcbdc7f0b5fb826267d78747cfa0c" => :catalina
    sha256 "e2638049d1e7b182aa5ad981436660969d029ee3a7b2afe0cb3a3906817578f3" => :mojave
    sha256 "0576fae054e001c3fd7954c5b013323aa0bb54d37c7c51b400cef87144d690a1" => :high_sierra
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
