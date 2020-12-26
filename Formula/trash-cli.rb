class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/72/ab/e35e3b8c51367dc6b4d4430f3141e93421a15f16e9f161acad7c2b640107/trash-cli-0.20.11.23.tar.gz"
  sha256 "c4c2d1a1f518b4de3de2b168f970bbeec739490204e0bf5c32a65004c09fa2ad"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5709ac7582a562b73ee9990da76d1e47eda1c9462de1b27c1002058a8bf4a95e" => :big_sur
    sha256 "3338c06b98502ac0541819df14c9750f60396a58c7c0f96fa2c94af1d13f6497" => :arm64_big_sur
    sha256 "181a25c6c47163b33789da438ddf5ed2f8b20be195a3ac1c2e4043b0a2ebcd90" => :catalina
    sha256 "c7cba34dc885096b61e2f3edb8ec473c625ae71342e42377e588a371ea475cdd" => :mojave
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
