class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200102.tar.xz"
  sha256 "547cd1c2f8dca904faac9e8d3964f1ef956c24bb12e3498da88dde95243c7f08"
  head "https://git.zx2c4.com/wireguard-tools", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "d5444429edc37a7e1847d99dbc7aa1539e1ea2860d9daf28b61501299768c7ac" => :catalina
    sha256 "bb6f8cd868a9025cc9b3d36374beadea601045a2d3b21b30d552f3cdb670d390" => :mojave
    sha256 "2fb7b18d533908079819505d32ff8c1e5ddf26c4c3d5a999e9e9d9c0b64617da" => :high_sierra
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
