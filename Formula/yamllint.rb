class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/54/21/4bcf449477392d5896128ee1e21dfb7ab640a77e338a2e34748cf38fed0a/yamllint-1.27.1.tar.gz"
  sha256 "e688324b58560ab68a1a3cff2c0a474e3fed371dfe8da5d1b9817b7df55039ce"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67777c3418b76852325cf34ffa724992f88fa5263f157a2b2a8e06960a377d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c67777c3418b76852325cf34ffa724992f88fa5263f157a2b2a8e06960a377d1"
    sha256 cellar: :any_skip_relocation, monterey:       "aa547d5e884bdad1ec66857fcd89ed2bfe612f96b88d42f5bb4a519a75679f17"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa547d5e884bdad1ec66857fcd89ed2bfe612f96b88d42f5bb4a519a75679f17"
    sha256 cellar: :any_skip_relocation, catalina:       "aa547d5e884bdad1ec66857fcd89ed2bfe612f96b88d42f5bb4a519a75679f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d03eed79e2f94d57cfd6007acff2aa09902dc283680a0d0e8c8e49f7a526edb2"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
