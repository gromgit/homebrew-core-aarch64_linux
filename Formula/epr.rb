class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/7e/1a/cfaa2e62daa81730e8a176d266264d863fff321fffc1bcc6ee91847ffee5/epr-reader-2.4.10.tar.gz"
  sha256 "23d5b7e04022097c49833497d298e1c7cb2152cd278ab96904fb697460e041bd"
  license "MIT"
  head "https://github.com/wustho/epr.git"

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
