class MultiGitStatus < Formula
  desc "Show uncommitted, untracked and unpushed changes for multiple Git repos"
  homepage "https://github.com/fboender/multi-git-status"
  url "https://github.com/fboender/multi-git-status/archive/refs/tags/2.2.tar.gz"
  sha256 "d26a71cd2efd80416c28d59632665341bc393d2d5fdde20dd588f959b0faea6a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/multi-git-status"
    sha256 cellar: :any_skip_relocation, x86_64_aarch64_linux: "cf787cf659535caf0d1a6e09f123e506d043b4085ea29d28346dcd94a8feb300"
  end

  def install
    # This is what the included 'install.sh' script does, except that
    # we use Homebrew's preferred location for 'man1'.
    bin.install "mgitstatus"
    man1.install "mgitstatus.1"
  end

  test do
    mkdir "test-repo" do
      system "git", "init"
    end
    assert_match "./test-repo: Uncommitted changes", shell_output("#{bin}/mgitstatus 2>&1")
  end
end
