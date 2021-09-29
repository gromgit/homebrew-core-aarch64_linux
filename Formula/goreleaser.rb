class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.180.3",
      revision: "c7580bf49f1df01d0f0c9be4ef85c5161a165978"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e71e18fdf15c47145a217276ab2d285193dd97dcb7670c71f86c7196e80f223"
    sha256 cellar: :any_skip_relocation, big_sur:       "364220fd16774a48135a05e059fc7e551abf1003294f9f706af37bf41255cfc6"
    sha256 cellar: :any_skip_relocation, catalina:      "cd9da392e9f8af9d571aa1eee7e7b34660a0ab8cdbca8267a4b1d5249bb4a58d"
    sha256 cellar: :any_skip_relocation, mojave:        "7950a1be8210331b0b6a6b511ce7b8064c5eaebbc5b325df28b0cc2ae81a35dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "112ad6767ecb6a0c58708b89f7b6bab62a2d3f30b8607a30784590badcdb7a28"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)

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
