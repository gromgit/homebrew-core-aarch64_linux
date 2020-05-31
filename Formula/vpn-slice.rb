class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://github.com/dlenski/vpn-slice/archive/v0.14.1.tar.gz"
  sha256 "75403735e0ff95ff8b1c9620e5d272fbde37d6a54881de5582956aeb31ff01b7"
  head "https://github.com/dlenski/vpn-slice.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "914baaa49147f8d501661d64f36149b540c6f41d4aeda50c1f6ece60efa74156" => :catalina
    sha256 "3952bc6d4d3ebc7f2276d226096880c628a7450dd0164753fa15681a4a713060" => :mojave
    sha256 "d03feef3cde8d44fa5fe0ec33020127471c5eb1c8e299f41b2b78bbc0d3ecab8" => :high_sierra
  end

  depends_on "python@3.8"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # vpn-slice needs root/sudo credentials
    output = `#{bin}/vpn-slice 192.168.0.0/24 2>&1`
    assert_match "Cannot read\/write \/etc\/hosts", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end
