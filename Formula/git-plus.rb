class GitPlus < Formula
  include Language::Python::Virtualenv

  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://files.pythonhosted.org/packages/d3/2a/c573678f7150f35305f50727bcfd41edf1415fb1e523860f0f0788d99205/git-plus-0.4.9.tar.gz"
  sha256 "b9a9dbbffc030a044cb7d9ee46b3fe1b683162cee52172c7349eda8216680ec6"
  license "Apache-2.0"
  head "https://github.com/tkrajina/git-plus.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/git-plus"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "efcb7b32fc6e87160f8986a590bcde140e324f666a72603ca0b955ed124df484"
  end

  depends_on "python@3.10"

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
