class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/eb/9b/c52f413db42d7f8fef68128b22d0df52e2757012856c1a195257e0ebffa1/twarc-1.8.1.tar.gz"
  sha256 "721cd66bba99f6fb36b0783903f947bef0086ef0fb15c488b1175d42695e38df"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d463d681bebe34f4ee2377aff7ca81e72c92fb72f1c56785b51dc379a1c033f" => :catalina
    sha256 "f5ebd735359e2ea60c6179c779a658778ec1f6b350f4d84564f346b3e1893b50" => :mojave
    sha256 "1a08c08e16628701da56d8c71b4ba5dbb76fd6a04ceb5620d964cb8a6ef95bd9" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "twarc"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
