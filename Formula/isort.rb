class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/31/8a/6f5449a7be67e4655069490f05fa3e190f5f5864e6ddee140f60fe5526dd/isort-5.8.0.tar.gz"
  sha256 "0a943902919f65c5684ac4e0154b1ad4fac6dcaa5d9f3426b732f1c8b5419be6"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9eff09e8303490635ecd70945590d7449b15f4978c1651711991dece289b4d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "454f81b392904f6c3b051968349f2547be7cf142f63a34bf2771d65768c051dc"
    sha256 cellar: :any_skip_relocation, catalina:      "0795695d5fd3d18e2b46a119acf132a66be387ad7515d5eb6f0686db4da28526"
    sha256 cellar: :any_skip_relocation, mojave:        "4e2beae6fc40007208704b756f4abc60c11ef04ce7e164f128bb3f22d884cf97"
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
