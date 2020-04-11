class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/af/bd/0a60e89ff992a52ae519e1b849256f964dd75f00f12061c185ff177afe44/git-plus-v0.4.0.tar.gz"
  sha256 "12b048f0d0e3bc6af3ac2acd04cfd11f56f1a67d6c13a93fc4caa176102364c5"
  head "https://github.com/tkrajina/git-plus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "390aa755f2b485bebe65cda7a44d01a0d172b8b80298b1f853ef15c0a3be158d" => :catalina
    sha256 "a445dc8b3427c5cfb1d4c5643c1a717e2a4e5c88ec40691618c70f88ae3776e1" => :mojave
    sha256 "f32c1d766633e5a057f3ede7fb6f70d165bb9494461d56f4201b56e40946506f" => :high_sierra
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
