class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/54/21/4bcf449477392d5896128ee1e21dfb7ab640a77e338a2e34748cf38fed0a/yamllint-1.27.1.tar.gz"
  sha256 "e688324b58560ab68a1a3cff2c0a474e3fed371dfe8da5d1b9817b7df55039ce"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c057a4694aed5f32f8eca106e864d7c5d9bd4e087127de66e9efadb0ae449a74"
    sha256 cellar: :any,                 arm64_big_sur:  "b3e27226bc2f9371af7696daec800a2f9a1a1d614984d396e4f3c74f72108563"
    sha256 cellar: :any,                 monterey:       "99c0274cc8365bcaea73c653606820c5c6b62287e276e4a30acc7b7f787bc2c7"
    sha256 cellar: :any,                 big_sur:        "93c09491a0282d78153a31d5d907cacf05e28276a5c5614ed2ad7b0ef0258213"
    sha256 cellar: :any,                 catalina:       "ee717732f115e66a33ce04267941ea69e960fe589a72b3d5ffce6907ec44faf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f5d46f6ff31a65292a27c6739018d978dd19d0f0b1537623cab8b74ac21cfc"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
