class GitCodereview < Formula
  desc "Tool for working with Gerrit code reviews"
  homepage "https://pkg.go.dev/golang.org/x/review/git-codereview"
  url "https://github.com/golang/review/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "b79b296bc2794dad15aefff8f095ab475422377010ac6546fe30c7dea4306cc1"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/git-codereview"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5feaa66957ff4ba4d790a8b9be4979b981c6bfcc5ce67be17cc4f1a58c10789c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./git-codereview"
  end

  test do
    system "git", "init"
    system "git", "codereview", "hooks"
    assert_match "git-codereview hook-invoke", (testpath/".git/hooks/commit-msg").read
  end
end
