class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20200923.tar.gz"
  sha256 "dc9988d9a696152b5066f9d52dfc24cb898275b5c22a9f420cb901115901c324"
  license "GPL-2.0"

  livecheck do
    url "https://www.caida.org/tools/measurement/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "2777883e811d43e44eeb5b749ba5fed240fb771951a55fd31ba1a3fff378c440" => :catalina
    sha256 "071b43792714b1cef71af5921fb3b4ffea71c7b6df69361762d1588ee255653d" => :mojave
    sha256 "b3169722c61bc6f10acef02e6b22533ffc9704598cb9923c3f2f58b6f91accd2" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
