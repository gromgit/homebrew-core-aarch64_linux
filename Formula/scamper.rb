class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211212.tar.gz"
  sha256 "ae4f84aef28373701568a9e57ec44a31ec20871c33c044a5272de726acbd2d13"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d640605d3a5ab0e7783e9f43dcbcc11ea5d1e0e73c6a3911a386aea3836e8dfe"
    sha256 cellar: :any,                 arm64_big_sur:  "35fe5995a6581b107914360a1e19ba0c80b12909957575b88a340a46f2fd145d"
    sha256 cellar: :any,                 monterey:       "be47fb7a5e1600008d73ba8464050f2ef4f088a346a9447202db257b62e9fec2"
    sha256 cellar: :any,                 big_sur:        "17375cca8a4ea9467d21266204387e917add13123f605a91f5645ecbbc9ba688"
    sha256 cellar: :any,                 catalina:       "20dfc6f01fe9dde757d1517d7a1f80705e5e73793cfaac92a48edaf7d6ae9751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "447c9c74ff9ff4142d8aa85dd08b09637507110a9dee0960ad253358f3c81ce5"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
