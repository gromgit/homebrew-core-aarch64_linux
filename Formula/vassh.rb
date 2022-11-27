class Vassh < Formula
  desc "Vagrant Host-Guest SSH Command Wrapper/Proxy/Forwarder"
  homepage "https://github.com/xwp/vassh"
  url "https://github.com/xwp/vassh/archive/0.2.tar.gz"
  sha256 "dd9b3a231c2b0c43975ba3cc22e0c45ba55fbbe11a3e4be1bceae86561b35340"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vassh"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b2fe722f497a089ce894ac780c6b86d88a01c10baf77b2399a883735475066a8"
  end

  def install
    bin.install "vassh.sh", "vasshin", "vassh"
  end

  test do
    system "#{bin}/vassh", "-h"
  end
end
