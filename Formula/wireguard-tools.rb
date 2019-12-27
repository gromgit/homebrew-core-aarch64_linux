class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20191226.tar.xz"
  sha256 "aa8af0fdc9872d369d8c890a84dbc2a2466b55795dccd5b47721b2d97644b04f"
  head "https://git.zx2c4.com/wireguard-tools", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "a1b7da4446cf1660b0c29d3ed3cacf9db5c6fba70d174c718aae69d4d3cae5de" => :catalina
    sha256 "64f13166f0bdc97d7685f26343bb25de53027d935e9ec750ce2b59c49033eda8" => :mojave
    sha256 "37ffbc30f283c5d47e015b08be14f71b42402eafb2da38a08cca9119d3e89e8e" => :high_sierra
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
