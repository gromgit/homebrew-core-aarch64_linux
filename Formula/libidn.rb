class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.36.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.36.tar.gz"
  sha256 "14b67108344d81ba844631640df77c9071d9fb0659b080326ff5424e86b14038"

  bottle do
    cellar :any
    sha256 "a720f31e3d82a3e537ae2fbaf88bdfcf537b3452615a170c72714c111df4a661" => :catalina
    sha256 "d3741facdecc039b53d64392b6f8f4377a01d38bd0ce388db1d4d3606c7d5da9" => :mojave
    sha256 "94e508f0b66a0c37c7a05dad6fff49542439a05cf913980caff4142e58ae998f" => :high_sierra
    sha256 "ddbdf99759b5bf8840afdf4b50de61b3770fab70d26e08c0cd54c8df54c7da7d" => :sierra
    sha256 "11f95f7689146cda4ee3960295cd39f9ec5c613871e35c27d0260c7bd8eeb199" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
