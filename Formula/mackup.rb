class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/69/22/281e7a060e87343493ed3fdceaf0305947b6c99addb4ef70a2ff0bb0fc2e/mackup-0.8.34.tar.gz"
  sha256 "3a8a0700b72c274706ccea2d4c0d90109a29cda73a68b8c9357a06b919eefbb0"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eb529806486a3980086ee3ddd4cd0c2b4238c71762e23befb41132f8bf70913"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eb529806486a3980086ee3ddd4cd0c2b4238c71762e23befb41132f8bf70913"
    sha256 cellar: :any_skip_relocation, monterey:       "080eb406349a8ef4c22adb53e6dd0cee4020278599349a467de1b0c686844bf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "080eb406349a8ef4c22adb53e6dd0cee4020278599349a467de1b0c686844bf9"
    sha256 cellar: :any_skip_relocation, catalina:       "080eb406349a8ef4c22adb53e6dd0cee4020278599349a467de1b0c686844bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43691496fed4a9b67c9ea19bea31cb66a9f2a95c1aa599c8c6a3116131265eb8"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
