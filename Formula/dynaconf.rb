class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/f0/0e/3c102db167de3e2bb3a36a680a89c27b9b08d9f856b2164cc1a03db96f1c/dynaconf-3.1.9.tar.gz"
  sha256 "f435c9e5b0b4b1dddf5e17e60a1e4c91ae0e6275aa51522456e671a7be3380eb"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dynaconf"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "25a42f49e27a32ddad851b0e60c2f9faedc3b199aa1f5bee5d13ad798afe5101"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
