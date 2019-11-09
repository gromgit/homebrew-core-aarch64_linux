class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20191102.tar.gz"
  sha256 "a5f1856546a30d8362377a1489de8c566c31c3b93744909cf6bea5b7cbd92645"

  bottle do
    cellar :any
    sha256 "5465091cd5142c1db0bc400897bdfc3045d3111f6fd8c6ed903f785a285e0128" => :catalina
    sha256 "6d3ebdb312d61258244b3e537b8a210d50e4933975ffa12677c7e40e0866b7d3" => :mojave
    sha256 "6d714da5b057f7033a2b9590c989ebf6a01dd71c785e71cb6f3f9217d54f05a8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
