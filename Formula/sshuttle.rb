class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/ee/5d/8eb1de9ed90732309cc8c64256d2e35de3f269713d707e1074a37d794665/sshuttle-1.0.4.tar.gz"
  sha256 "21a11f3f0f710de92241d8ffca58bebb969f689f650d59e97ba366d7407e16e5"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/sshuttle/sshuttle.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7f4c70a8575c778a65de46eebfe61151945b37c0d958a66fca7aa5ead3ab7c1c" => :big_sur
    sha256 "9b1b795e0817955ebc66c0a8ddfa18e41951c6cea2dea4126cd346c3afbbd5a3" => :arm64_big_sur
    sha256 "c9d9ba4721a391e1e02484003fc995fd3a11b8f2e2a803353f24e0b5ef87da78" => :catalina
    sha256 "874db8f6c57d63d054b1e24d6ad083f218cbf366d926406faa78ce4c0bcfc987" => :mojave
  end

  depends_on "python@3.9"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/3e/d18f2c04cf2b528e18515999b0c8e698c136db78f62df34eee89cee205f1/psutil-5.7.2.tar.gz"
    sha256 "90990af1c3c67195c44c9a889184f84f5b2320dce3ee3acbd054e3ba0b4a7beb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/3e/d18f2c04cf2b528e18515999b0c8e698c136db78f62df34eee89cee205f1/psutil-5.7.2.tar.gz"
    sha256 "90990af1c3c67195c44c9a889184f84f5b2320dce3ee3acbd054e3ba0b4a7beb"
  end

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    virtualenv_install_with_resources
  end

  test do
    system bin/"sshuttle", "-h"
  end
end
