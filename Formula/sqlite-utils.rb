class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/3a/40/9461a52974c5f5eb1ec5eb804ef3a84c5da878f443eea368c88b7c5c428f/sqlite-utils-3.7.tar.gz"
  sha256 "86f7ef80ca52fbf8c5692bfbf41572cb07421e7030f96278b977a439d4d95b06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e90efc9ccf7a756ae54730efb14f292cf560c0b19f7e0e9bd09adbdedd067faf"
    sha256 cellar: :any_skip_relocation, big_sur:       "b31059d3c5919e38195baab3580f5e867030e2f0defde97c9af88b8446d6cde0"
    sha256 cellar: :any_skip_relocation, catalina:      "cdd58ddff8316de85d4b7b024444d13632279312e5fef6bc1121cd47a72a19b3"
    sha256 cellar: :any_skip_relocation, mojave:        "af4e691a4c3fcf2687b1c587469b9e926507a760a8e716cc4712089eceb45a18"
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
