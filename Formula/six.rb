class Six < Formula
  include Language::Python::Virtualenv

  desc "Python 2 and 3 compatibility utilities"
  homepage "https://github.com/benjaminp/six"
  url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
  sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23e2fecb3df6d6b474a1bc65d1ba03d9512dd797be4d2fac1ccfd0f1f99499c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "269efcb8c4551c623dbeab039dc890174b6f6dc17a387cd7bb59e5646f32fb24"
    sha256 cellar: :any_skip_relocation, catalina:      "be23fc6cc8ad85469db1650f9fbf42cd57e537bbe431dfbdfd6e18bcddd45cbd"
    sha256 cellar: :any_skip_relocation, mojave:        "427c2793a3ba839d8546934b7c1f20d009b6c6e2cd1d703d33f3c0b943f2e904"
  end

  depends_on "python@3.9"

  def install
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import six
      assert not six.PY2
      assert six.PY3
    EOS
  end
end
