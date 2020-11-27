class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.20.11.23.tar.gz"
  sha256 "dbe59f60f3d0fbe95aedcc64b927e8d4d8ce62fc0dd9b6a0b8ffae2372865f36"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfc93dc305e620eb718ce9b9b678d441facd80e08ffb1a796b4df00351f3eb2c" => :big_sur
    sha256 "128888973578e454a51de84730d0003039081a46902fc644b34c75d903177a8a" => :catalina
    sha256 "6cb8a2b0d695b6eb65835110d3d45ab5b63240a7feb423fd548b7df551b32d5b" => :mojave
  end

  depends_on "python@3.9"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
