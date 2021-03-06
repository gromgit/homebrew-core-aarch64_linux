class GitBug < Formula
  desc "Distributed, offline-first bug tracker embedded in git, with bridges"
  homepage "https://github.com/MichaelMure/git-bug"
  url "https://github.com/MichaelMure/git-bug.git",
      tag:      "v0.7.2",
      revision: "cc4a93c8ce931b1390c61035b888ad17110b7bd6"
  license "GPL-3.0-or-later"
  head "https://github.com/MichaelMure/git-bug.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/git-bug"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ec05f48e2430843196a8c548e4745739634f2b4be5167b2ca3af2bff48976cad"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    system "make", "install"

    man1.install Dir["doc/man/*.1"]
    doc.install Dir["doc/md/*.md"]
    bash_completion.install "misc/bash_completion/git-bug"
    zsh_completion.install "misc/zsh_completion/git-bug" => "_git-bug"
  end

  test do
    # Version
    assert_match version.to_s, shell_output("#{bin}/git-bug --version")
    # Version through git
    assert_match version.to_s, shell_output("git bug --version")

    mkdir testpath/"git-repo" do
      system "git", "init"
      system "git", "config", "user.name", "homebrew"
      system "git", "config", "user.email", "a@a.com"
      system "yes 'a b http://www/www' | git bug user create"
      system "git", "bug", "add", "-t", "Issue 1", "-m", "Issue body"
      system "git", "bug", "add", "-t", "Issue 2", "-m", "Issue body"
      system "git", "bug", "add", "-t", "Issue 3", "-m", "Issue body"

      assert_match "Issue 2", shell_output("git bug ls")
    end
  end
end
