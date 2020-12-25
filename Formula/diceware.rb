class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/d7/af/85373be6b11706fa1392e52d7fcd47df47f661e238251c931d469e62c5bf/diceware-0.9.6.tar.gz"
  sha256 "7ef924ca05ece8eaa5e2746246ab94600b831f1428c70d231790fee5b5078b4e"
  license "GPL-3.0"
  revision 3

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "82ed5a515e4ee8d549911fe48a078ae9b149bb9e7a46f4a9042e7635fc4ba977" => :big_sur
    sha256 "a509ee5a4669ed7ca0af8dd384f45ce7639221c471a937c899683f7aaee649f7" => :arm64_big_sur
    sha256 "135d84622bbe9328996ba5128e05190e23801b7802440409b80d1a4a50b7daba" => :catalina
    sha256 "42561d7b56413cdaed177753e1de2d2c9d7e882b36023e1fa112d19efc25de87" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
