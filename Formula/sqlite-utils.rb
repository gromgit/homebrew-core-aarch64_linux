class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/ca/70/3d6278ef2c8194a62e0080a237027472b8942a2ece3a1efc241b41d17f85/sqlite-utils-3.5.tar.gz"
  sha256 "8bd4a74fe0dc40e72e8d5db96c3fd2355d6e440d8881f8925a11169500b94e20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f260407a2dfcc1a0bfce96a15acb55658e3810ef8cca53fbcf68740dbe7062d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ddf208a98c2059bd29e6154e2ccf25ec7c2e22289c55cb90af09c23bf4325d33"
    sha256 cellar: :any_skip_relocation, catalina:      "b1b1cea61aa9f48e97e64778fcad2cceabce566b35197e6408816d8f43afb800"
    sha256 cellar: :any_skip_relocation, mojave:        "c725847a9da72734c94db1a338eba60c7463bb25d3e26fcda17106bd241b5158"
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
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
