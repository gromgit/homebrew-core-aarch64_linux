class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.15.tar.gz"
  sha256 "3edc8ea1551fdf290d6bba721105e2e2c23964070ac18c13b4b8d959cdf6116f"
  license "GPL-3.0"
  head "https://github.com/visit1985/mdp.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mdp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "961f394b3da3ccc4f6817fcc0187478114ca147cd7645ee30e9098144bfc0229"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
