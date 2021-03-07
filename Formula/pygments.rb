class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
  sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bdd43f4f10f9f23bf91a6f7e4b28f89a1616b18909d556137a2170968d62091"
    sha256 cellar: :any_skip_relocation, big_sur:       "229adb25ab2c136882a0e418628df9eadc34d32b4a2a3757bb423379b443a7d9"
    sha256 cellar: :any_skip_relocation, catalina:      "0a39997ef2cef1a1457375f92d586605d39fff33a1880fcb98f70cd1bc47a0c4"
    sha256 cellar: :any_skip_relocation, mojave:        "3aab5b07c744cb7d0721367eaab16e9eafa292c589b97f03e2e0e9cfd8426cf4"
  end

  depends_on "python@3.9"

  def install
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_predicate testpath/"test.html", :exist?
  end
end
