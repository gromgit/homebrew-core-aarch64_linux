class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/6d/bf/9fd2ed5a413908196bbc334cdf272e59f17a32fef2854b811ce9ed0007e7/trash-cli-0.21.5.11.tar.gz"
  sha256 "57d95aa1b719cae85d95d3761a7ca5a59efbeb7fe6a25d2723250e34fd302003"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0bbacfe2c0ab14f551eef353500d03401919db4abc55604d4c1537c5e62601ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d964410fe1e794ff8d5c7f7ced7337a9f42de9fed2777ca4a752572a91e2c3e"
    sha256 cellar: :any_skip_relocation, catalina:      "36b31d39e4d82de0497b190eb422f04d2e25c417032bcd2c1ce5e649cf4a4ea5"
    sha256 cellar: :any_skip_relocation, mojave:        "47d5abf17c47da796f6c2f707b676d7bb067715474a5faeb6a3d46e1966421fc"
  end

  depends_on "python@3.9"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

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
