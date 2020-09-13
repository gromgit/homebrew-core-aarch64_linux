class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/5d/9d/208733ccc91b1d2c2af7270ffe3def197504bd8da875bc3fa1dc75039795/Pygments-2.7.0.tar.gz"
  sha256 "2594e8fdb06fef91552f86f4fd3a244d148ab24b66042036e64f29a291515048"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "03299404beca19adc6f39a8f32fdbeb734fa90f503333daad3df13a92532c085" => :catalina
    sha256 "6ae3cb101d7e035a157c54391c7c0f994510aeff7559de32e277e1a34aaf621c" => :mojave
    sha256 "3467adc4fc47a70c8f1bcf554abfe3c65a9161eb8c4fa18ca6f1520910850354" => :high_sierra
  end

  depends_on "python@3.8"

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
