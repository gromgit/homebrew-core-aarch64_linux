class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.21.0.tar.gz"
  sha256 "6ce317f7ee5895b6232a70fb1e9870cfcb15702b19123cfa63cd1b55f4f11ac8"

  bottle do
    cellar :any
    sha256 "c9af991306882a4fe21500a52a63d6e110d09e9c4ba6c9da2558a99bdcfcce8f" => :catalina
    sha256 "1aee52bbc89a796c87eb838ec79de9f2d7e1ea371bf64bd4ca70b430966f8360" => :mojave
    sha256 "16ff7600ad8d42d077f931bbd968ee41425e1a6c6a9e5fd4f827e83ca5b40bf1" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ce/f2/d35c292da8fbff725625a17ae40f48f933070acd5ccddb03d8c09d81758d/pathspec-0.7.0.tar.gz"
    sha256 "562aa70af2e0d434367d9790ad37aed893de47f1693e4201fd1d3dca15d19b96"
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
