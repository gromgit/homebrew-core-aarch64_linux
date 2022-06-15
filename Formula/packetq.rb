class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.7.0.tar.gz"
  sha256 "6c275d1a0139ed191973593895ac0b313866a4bfb832e969eec0650d1c03f82f"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/packetq"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3365d92d5ffb5501d064f4d0c070ab92ba1374b3d41d59737cd89caafea5ee24"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end
