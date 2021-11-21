class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211026.tar.gz"
  sha256 "be75919a59d73227598260668b7ed75f6a710507310ca9827789b18cd7dda684"
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

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
