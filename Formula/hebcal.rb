class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.20.tar.gz"
  sha256 "61021362e72f21bd7faacb5ff65605762344c1d7eea99bf362b566a4556e222a"

  bottle do
    cellar :any_skip_relocation
    sha256 "82e64fcd79301440644f65bc414f273d5870b1d11af23f78a8c4f3f919dad163" => :catalina
    sha256 "6853acd106ae9288cf2a9dd2fbd276d79bb4e416fda6a4d6a1065a5c3ed74b10" => :mojave
    sha256 "dd52935bf77f4a5e3ca8a206abe2ef8909dd5cae8415bfe6d7bf788881ffe138" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
