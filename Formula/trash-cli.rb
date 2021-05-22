class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/a4/aa/0c655df212bcac0415f8ffe5093012439a13f12b8f46404708ba879a60c5/trash-cli-0.21.5.22.tar.gz"
  sha256 "73cc1ce9b926c2c120bf57ef8fb444398235071d4a4187cbd9bb3d81104307c6"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ceff5e83cf4d1616a7d2f0b6a59b37d8d4dbc098a856b78b2bcb7db2cc711d0"
    sha256 cellar: :any_skip_relocation, big_sur:       "aba7676e94dadddfabb380a02cab22f917fb54da71eece95848209cdf47d1b37"
    sha256 cellar: :any_skip_relocation, catalina:      "36b10e8b68ac536eee2a3b646c79b18094cb5ddf76c4369c854ebc8a40f4bd1e"
    sha256 cellar: :any_skip_relocation, mojave:        "486b30096b8815a9d968ef78b5c6031309ee44c81b96953d57baeaad67a1163b"
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
