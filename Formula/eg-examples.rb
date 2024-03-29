class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/8b/b7/88e0333b9a3633ec686246b5f1c1ee4cad27246ab5206b511fd5127e506f/eg-1.2.1.tar.gz"
  sha256 "e3608ec0b05fffa0faec0b01baeb85c128e0b3c836477063ee507077a2b2dc0c"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/eg-examples"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f87688ce2ed660ee7ec67849390cbc0f925fc10d22cd5107063b43cc25502f16"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
