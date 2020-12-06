class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/29/60/8ff9dcb5eac7f4da327ba9ecb74e1ad783b2d32423c06ef599e48c79b1e1/Pygments-2.7.3.tar.gz"
  sha256 "ccf3acacf3782cbed4a989426012f1c535c9a90d3a7fc3f16d231b9372d2b716"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a97e775ec600eac6459e812a5b56d6be6e31942eb700650749becf84f97d7f33" => :big_sur
    sha256 "ebf72c4fbc6b7c4992ecb815a9092f52e6a862deeb6ba2e4534aa62701a40e02" => :catalina
    sha256 "c3fa220fa15087e40f4df61f3c7c249b8bec78177d6609306a92b3c1af92ecb3" => :mojave
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
