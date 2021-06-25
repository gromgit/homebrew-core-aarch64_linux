class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://github.com/smxi/inxi/archive/3.3.04-1.tar.gz"
  sha256 "1f029f5f667e0396ab9f6ba2c51cf7937ea38bf504d1621a8c50e19205a7a671"
  license "GPL-3.0-or-later"
  head "https://github.com/smxi/inxi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b73c5f42d790f29d92980369bae01bca56ce8b63ff77648f30d2ea3238c2bc2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae0178948f7f5f7ab4a70754e4f95cb7ed665c1fdffa94643ae9496bad625788"
    sha256 cellar: :any_skip_relocation, catalina:      "ae0178948f7f5f7ab4a70754e4f95cb7ed665c1fdffa94643ae9496bad625788"
    sha256 cellar: :any_skip_relocation, mojave:        "ae0178948f7f5f7ab4a70754e4f95cb7ed665c1fdffa94643ae9496bad625788"
  end

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")

    uname = shell_output("uname").strip
    assert_match uname.to_str, inxi_output.to_s

    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
