class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.167.0",
      revision: "2375c93359f9a6a56289564fd1fa9dfd1889b277"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28b25f80599f80f89d8afbfce3c681023e1f6418518c71bdda03367f198dfdbd"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe94f3a6fa0215eb4292ab45a1ba2aaa52ddee024c1b698d66568471fba3b04a"
    sha256 cellar: :any_skip_relocation, catalina:      "f3f4bc34a50d2c4c72ccc62956a0d926e9503d4e97c90633f1eac833eabd7c5e"
    sha256 cellar: :any_skip_relocation, mojave:        "ecb5ae43375f4d6aa98bfb8e07e4a60b9c48ded5a0173978b1eb69c8d52ac788"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
