class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag      => "v1.0.2",
      :revision => "8c91958ff3805dbdef9b659061a0de25ba4b34f8"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1100d1c129245a0c052f86339cdf7d81fdb2c77bc1c80497b47ad8dbdd644a0" => :catalina
    sha256 "f511c4a3e7bad02e2b64d8e33e6985b2b6ff03c41272172638a63f08f8628a0c" => :mojave
    sha256 "db3e41b9224be3181cd4947aaab8b91f19a1495431de0bea6217acb6ddf49691" => :high_sierra
  end

  depends_on "python@3.8"

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
