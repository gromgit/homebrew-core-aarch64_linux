class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.22.1.tar.gz"
  sha256 "950bc1b3d3a2622912a86a3466f87d72eff05be76dd0cbe7dcf4cd404db0778d"

  bottle do
    cellar :any
    sha256 "f78dfa3df5f598e9a8353044a9c4d793cd17ed47af4d46ddb4cb7be422c43a85" => :catalina
    sha256 "1f77200b1f6d418a123b841ce63c75d9a24b598297a53df38cc1196159f68fe5" => :mojave
    sha256 "89f71e6ceacaa74cb23742311638e9f1ffd432e278e95258fd4440eefae040bb" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/93/9c/4bb0a33b0ec07d2076f0b3d7c6aae4dad0a99f9a7a14f7f7ff6f4ed7fa38/pathspec-0.8.0.tar.gz"
    sha256 "da45173eb3a6f2a5a487efba21f050af2b41948be6ab52b6a1e3ff22bb8b7061"
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
