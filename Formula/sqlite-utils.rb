class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/0d/7e/111bde53d3f4c4f03152963086a28aa11ea5536c6980f64b48eff43d7c7d/sqlite-utils-3.6.tar.gz"
  sha256 "582a9bcf4b6cb32ee2efa4a0d8f79ec630e8965ca93c69ceaaa7d424e1c01560"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92efb0b2d2abd6ef9dd6aa99c9a9a5e714833a9fd5098a55fbfc98c1fa540b04"
    sha256 cellar: :any_skip_relocation, big_sur:       "86b279664f109615a76daf196c8f347b95e6114fc7e3ecd469d7a0d20ba783c2"
    sha256 cellar: :any_skip_relocation, catalina:      "7b708730f173746ac25d1f1205f856de1930bcd00ebf4104af95e2a64aeba781"
    sha256 cellar: :any_skip_relocation, mojave:        "9cc9ad54dacbd5b262948f3b0bc409546d48d0c75616b189a884575fda6eeb22"
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/69/44/6c7326b95268c16cf8dc1376ed1a4f404fa9fd04c1371c0917d3f2806832/tabulate-0.8.8.tar.gz"
    sha256 "26f2589d80d332fefd2371d396863dedeb806f51b54bdb4b264579270b621e92"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
