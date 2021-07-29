class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/1c/34/ed9178b5b23ade4561bf77b91856e0e3bc094620fd81bd74d535817a0f0d/isort-5.9.3.tar.gz"
  sha256 "9c2ea1e62d871267b78307fe511c0838ba0da28698c5732d54e2790bf3ba9899"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "782fbf745d76bc86201818718026f50e24c16e4b7e48e39e0087539195b49319"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9d947b55140ca255b947f96e77bb796619f4fc3e974e57f4defde87764e677a"
    sha256 cellar: :any_skip_relocation, catalina:      "7ca3e49c222871b0bb91520b180abf4ebf953b4f3aac7eab36cb67e710cbc24e"
    sha256 cellar: :any_skip_relocation, mojave:        "f9527c060b4d71740227719b26a43637d309d6c59c0567253aeca048508ba923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f923b3f1c41608e28549de5c00406419434841f981f96a7e2a2e08c2de4ae13"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
