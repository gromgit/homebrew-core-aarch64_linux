class Btpd < Formula
  desc "BitTorrent Protocol Daemon"
  homepage "https://github.com/btpd/btpd"
  url "https://github.com/downloads/btpd/btpd/btpd-0.16.tar.gz"
  sha256 "296bdb718eaba9ca938bee56f0976622006c956980ab7fc7a339530d88f51eb8"
  license "BSD-2-Clause"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/btpd"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4d72763ac2f2075366f7ed96a8255e17dccd5a867cdc199b060d1fe10aa2b018"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Torrents can be specified", pipe_output("#{bin}/btcli --help 2>&1")
  end
end
