class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/ee/a4/2ef9ebbe507592a37651cc327900f6e19ccc438858600c42e1611c62e8ee/trash-cli-0.21.5.20.tar.gz"
  sha256 "733bd5babd14955c0596b0340faaf626be1efd5ffd693ad1b227749844f9b800"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2f2ebdf4ea90ecb6dabd82619b194df39ffb54644413929c2667192d5bec947"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad1ecebf5875f4ac45d59089802091c0cf34cc57953c918ee057e0691d982b6e"
    sha256 cellar: :any_skip_relocation, catalina:      "e7abc294e34cfe148ee1215f8c48b83029275d8cf5e6551a34d7dc6b693fc521"
    sha256 cellar: :any_skip_relocation, mojave:        "a50fd31a94b57fdbf3d39804507449590e662acfd262c39b4bae40319d34bebf"
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
