class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/19/e6/86ff745dda86c18ac73a0f0c0871ae2c0fca8a3eb347437fce792f0a56e0/djhtml-1.4.11.tar.gz"
  sha256 "1b0b3d7c4d7207ec729d4720b3b5aa632d220bbee8df2f711d17457a2ce1ebc9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "156db4d7dfeef8a9aa5898d6ca4162a605ac15ab93015199001fc4ead8eaa0e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75e89b4ce44a2d31783106cb77870aaf15efdcf0a923248233c462bc0cf71003"
    sha256 cellar: :any_skip_relocation, monterey:       "dee172a2acd37f2b1803ee951a2c480b46f330ed0120989838df9cb4101e94af"
    sha256 cellar: :any_skip_relocation, big_sur:        "993260e8452c68f7524bb3297f4d919efb122bbfd2097a0f2835c7bdbef21b4c"
    sha256 cellar: :any_skip_relocation, catalina:       "709b2f2c10d7c4f7070fd6ac78fc4deae406ed3d67d5e8bfd9cf3dc8b95bf47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51589593b4f58688ff347b359dc2b7a08ae22e3b6cb907f0c6d7604ca8617722"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.html").write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF
    assert_equal expected_output, shell_output("#{bin}/djhtml --tabwidth 2 test.html")
  end
end
