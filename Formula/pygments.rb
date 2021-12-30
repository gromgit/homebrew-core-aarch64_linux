class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/1d/60/bb5bdd45e28a5acecf9273350b903fb8151ed899c4a384c983efd8a6730b/Pygments-2.11.0.tar.gz"
  sha256 "51130f778a028f2d19c143fce00ced6f8b10f726e17599d7e91b290f6cbcda0c"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d53ce366f416c9938cc35ae3ee6ff9902dfd7c2db3ebcc5cc8a7005a534af3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51d53ce366f416c9938cc35ae3ee6ff9902dfd7c2db3ebcc5cc8a7005a534af3"
    sha256 cellar: :any_skip_relocation, monterey:       "dce5f215526c725a466d875e13224453b90400253b447e75695786bb6fa332ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "dce5f215526c725a466d875e13224453b90400253b447e75695786bb6fa332ed"
    sha256 cellar: :any_skip_relocation, catalina:       "dce5f215526c725a466d875e13224453b90400253b447e75695786bb6fa332ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1981ab7e8b170a081a09a0af92bfdafbe23e8277e8c815a872acae4f045b3f94"
  end

  depends_on "python@3.10"

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
