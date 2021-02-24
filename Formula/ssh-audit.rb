class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/53/77/7db9fc7f87ece1978942aa3e8b905032da0862c62ede8112f9bb99c22232/ssh-audit-2.4.0.tar.gz"
  sha256 "197ec4e8c3f5ffca5627d944b85ed677faa798c218dc3ebb18430f5671c14d6d"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a35fc72d11c262a49aac55ac6b7a9697477dac8c605ea823d6c2e129bfe1e882"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb21c8795f1ff8146e521bf89085122d1c26fcd8231f146f520f6f3c11d81726"
    sha256 cellar: :any_skip_relocation, catalina:      "6898d35256e2463dc6710f06133a29c07ca9f77b3e13f01671ce9e7a98a95278"
    sha256 cellar: :any_skip_relocation, mojave:        "227e07ecf11af9dc5a1b4a1a7017c390a3caa5183327e73dba8a2607c648a01d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "cb1337c15074044b1dd7aa3a7026c7226bab0469dcee1ec0ed4eb960bc50dd4a"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
