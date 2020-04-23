class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/41/5b/3bd26811d311ae0b819487a3d97557ca0181de1c49a8dca1ab2c8dfac4f6/autopep8-1.5.2.tar.gz"
  sha256 "152fd8fe47d02082be86e05001ec23d6f420086db56b17fc883f3f965fb34954"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f1564bd116ad939ed8fd2a497865c416fbfa939cf94242cec47f1dd15cd0a06" => :catalina
    sha256 "7b3e36fcfef4a1475727845753b1f2a512fc1b982527cb5d0dba08b7fdd007df" => :mojave
    sha256 "9178c1e4b633eaad87163a18b55a7818969b3464569d6bb87ceba0e2d1fbb8b4" => :high_sierra
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
