class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.14.7.tar.gz"
  sha256 "a1a048714d7c7b237ea05f1fb51b3f3f4cdf90a16c60fa46f1df2eb5d96ce28d"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae9bac392efb1d469726eff02eb3bc33c27974691071d8a666e2c8d89253a60f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cba0fbd9f2764fcf7973bc33d9c941b72632806349d28f350b325692c8852b19"
    sha256 cellar: :any_skip_relocation, monterey:       "9711f7ba5e2830e0e1054717c964c8f4aaf42af821854f737bb71ecd204ee61f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8631cd8bd2f469f8d04cd21ffede1bca1e5b28611cb7c18c0e5cf8947bbd7b21"
    sha256 cellar: :any_skip_relocation, catalina:       "5c6b3874a95145c3cbdf5f032c9812d5a27571e3fadf8e7366d0db42bcdf572a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deedfd93506d1d2f9df34086475c2d1b8cef58a2722b2da4067aaf416f3e94ed"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
