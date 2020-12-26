class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/b6/08/b345475cfaaa542ae78a172d5b23979ad0577f15a32b16e5e54b2a7e80c6/invoke-1.4.1.tar.gz"
  sha256 "de3f23bfe669e3db1085789fd859eb8ca8e0c5d9c20811e2407fa042e8a5e15d"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/pyinvoke/invoke.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a8a306b122f96ee6721ad8f3693aa3c69648b42889ba3a77299437f24845030e" => :big_sur
    sha256 "27ae80e82efd0efcd6dc6cb38e90a3d598513234264a7c0f58b7644551ff2f17" => :arm64_big_sur
    sha256 "cc0d906afecf1a2aeed52b79f2b5706282afcbe7d0058b86bc8f9e1f63050d0e" => :catalina
    sha256 "a8e3c7cd07feab994337a9b8f148e2f2575fec9cf24c085f7b92001a3face903" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tasks.py").write <<~EOS
      from invoke import run, task

      @task
      def clean(ctx, extra=''):
          patterns = ['foo']
          if extra:
              patterns.append(extra)
          for pattern in patterns:
              run("rm -rf {}".format(pattern))
    EOS
    (testpath/"foo"/"bar").mkpath
    (testpath/"baz").mkpath
    system bin/"invoke", "clean"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean\" should have deleted \"foo\""
    assert_predicate testpath/"baz", :exist?, "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    refute_predicate testpath/"baz", :exist?, "pyinvoke clean-extra should have deleted \"baz\""
  end
end
