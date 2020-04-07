class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/ca/d3/bb1c5781415b2a4f7d48bcd4c62e735d5ebf40d4f8c325d654870bedb7a6/autopep8-1.5.1.tar.gz"
  sha256 "cc6be1dfd46f2c7fa00e84a357f1a269683985b09eaffb47654ed551194399eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3aae4544f049fe60fc115c16f5c27cb0ecfbfc3b1874606dfd6959a09552f9b" => :catalina
    sha256 "92c1b4cb88fac852a760e28fea55a3981bcbfb6334782ac2dd1d0f56d739f26a" => :mojave
    sha256 "964cf580cff80b8162ce2c94b51fa4a79b981b6321478c96f22c9a1bdbac46c9" => :high_sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
