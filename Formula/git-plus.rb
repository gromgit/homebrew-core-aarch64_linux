class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/73/b5/6cf7f0513fd1ef42b5a3ac0e342b3c4176551f60ad17fc5dbe52329f2b58/git-plus-v0.4.6.tar.gz"
  sha256 "bcf3a83a2730e8b6f5bc106db00b7b6be5df534cb9543ba7ecc506c535c5158b"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bddc068b92e8b64c9e2795eea8f1b52ffe4a69be0374080806157d867f2dee74" => :catalina
    sha256 "dd7f413430c9568a6f1d8a1821c672abb0e184b61403c2d3a366399fb23840a3" => :mojave
    sha256 "878c9fbdc776717eb21c07767bd67fc0d6ad412a69fbeab7ff12f9795076d8f3" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir "testme" do
      system "git", "init"
      system "git", "config", "user.email", "\"test@example.com\""
      system "git", "config", "user.name", "\"Test\""
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match "D README", shell_output("#{bin}/git-multi")
  end
end
