class Grepcidr < Formula
  desc "Filter IP addresses matching IPv4 CIDR/network specification"
  homepage "http://www.pc-tools.net/unix/grepcidr/"
  url "http://www.pc-tools.net/files/unix/grepcidr-2.0.tar.gz"
  sha256 "61886a377dabf98797145c31f6ba95e6837b6786e70c932324b7d6176d50f7fb"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?grepcidr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/grepcidr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "947e6a5de8c8cf4a8dbb75ab49658dd71cd44be3b575029f8d4890ed4b7d4efe"
  end

  def install
    system "make"
    bin.install "grepcidr"
    man1.install "grepcidr.1"
  end

  test do
    (testpath/"access.log").write <<~EOS
      127.0.0.1 duck
      8.8.8.8 duck
      66.249.64.123 goose
      192.168.0.1 duck
    EOS

    output = shell_output("#{bin}/grepcidr 66.249.64.0/19 access.log")
    assert_equal "66.249.64.123 goose", output.strip
  end
end
