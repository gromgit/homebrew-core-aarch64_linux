class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/e4/d7/dbea8d56f1d74205538e1e2a097ae8cc14a41b931e4308a42319afe70cd8/jello-1.4.2.tar.gz"
  sha256 "4848e52d92efee8053cb29acb3ae0d09086b4e037d637db50783708ee5aa5aa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9405c6a0354e8007cf25dd40b460f91fe477f20e80e7a24270d044e3ff6b1a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c342af99e9ad5e4ede36050bad7d8fc63a3a24bc4776e12f1fb41d7ad634a5f"
    sha256 cellar: :any_skip_relocation, catalina:      "8c342af99e9ad5e4ede36050bad7d8fc63a3a24bc4776e12f1fb41d7ad634a5f"
    sha256 cellar: :any_skip_relocation, mojave:        "8c342af99e9ad5e4ede36050bad7d8fc63a3a24bc4776e12f1fb41d7ad634a5f"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  def install
    virtualenv_install_with_resources
    man1.install "jello/man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
