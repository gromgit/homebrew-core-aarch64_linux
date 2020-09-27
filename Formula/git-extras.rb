class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/6.1.0.tar.gz"
  sha256 "7be0b15ee803d76d2c2e8036f5d9db6677f2232bb8d2c4976691ff7ae026a22f"
  license "MIT"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6bec6d92d79cabaac6e99d15c8bf1542cf97dcb190b7e77ad4eaa8e381cff055" => :catalina
    sha256 "6bec6d92d79cabaac6e99d15c8bf1542cf97dcb190b7e77ad4eaa8e381cff055" => :mojave
    sha256 "6bec6d92d79cabaac6e99d15c8bf1542cf97dcb190b7e77ad4eaa8e381cff055" => :high_sierra
  end

  conflicts_with "git-utils",
    because: "both install a `git-pull-request` script"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats
    <<~EOS
      To load Zsh completions, add the following to your .zshrc:
        source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end
