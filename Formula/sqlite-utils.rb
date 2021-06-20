class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/22/1b/a001100146c71d98ede33d9c579dcee12fc56d572a89e6cecb34713c2d01/sqlite-utils-3.11.tar.gz"
  sha256 "31bb8ffd3b264079271dc342ae840f3df1e94a3f59007f1782d7c8da9c185661"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97de8cd1ecf28c56ade037fb952ce902246814b889fcb876d1936be1e487b813"
    sha256 cellar: :any_skip_relocation, big_sur:       "77890a468241e36a74d8e3151cad963a0fb8d7937a305d4e60b01311a20f1eed"
    sha256 cellar: :any_skip_relocation, catalina:      "77890a468241e36a74d8e3151cad963a0fb8d7937a305d4e60b01311a20f1eed"
    sha256 cellar: :any_skip_relocation, mojave:        "77890a468241e36a74d8e3151cad963a0fb8d7937a305d4e60b01311a20f1eed"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
