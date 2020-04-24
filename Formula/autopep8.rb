class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/41/5b/3bd26811d311ae0b819487a3d97557ca0181de1c49a8dca1ab2c8dfac4f6/autopep8-1.5.2.tar.gz"
  sha256 "152fd8fe47d02082be86e05001ec23d6f420086db56b17fc883f3f965fb34954"

  bottle do
    cellar :any_skip_relocation
    sha256 "bde781d94e6eb9d19fefc497d0a7d1796c5469a51ad7f2b53e91d04890df99ac" => :catalina
    sha256 "d99c255d341b7d4ef1ce58e74ff884f2f50ae7341c8ba2601c6798b21e3fc37a" => :mojave
    sha256 "525a560a54f99aa3772f62853820d40e1d057a859c882d7fba8248866c3fc6fd" => :high_sierra
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
