class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/b7/8b/7c2200599c22b4ef6f3688f93c4f44065926bc05cbd38c31247b1348f9a3/isort-5.9.1.tar.gz"
  sha256 "83510593e07e433b77bd5bff0f6f607dbafa06d1a89022616f02d8b699cfcd56"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b6ee338a2f23a497ca00366c61f37b715706853f71f24f86364312333be5373"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f74871a6fac08d40dab69862f01cde96891370f21dee524f051f614c2710d52"
    sha256 cellar: :any_skip_relocation, catalina:      "4e49aad4bce47aadd0a00cf6579e567a5d21eac7e487c61b980c820b8e928ae1"
    sha256 cellar: :any_skip_relocation, mojave:        "120c5d1d55fefe15d0d921553785574efe85e3bef376941c39caf3c691d85eea"
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
