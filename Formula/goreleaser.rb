class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.2.4",
      revision: "cdcaf038c840247531576a8dd50f30e1615a988c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b544b751f0c8368c0ddf0b5337a5b074cb14b58e1d112e15da18ba5a2ad611ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23dd9e88e70f675530cd9b4ccf05214ed47fbc877f7dc8636bdd3e29e2c86597"
    sha256 cellar: :any_skip_relocation, monterey:       "bfd7ddc28a67e286791dc5949cfcdaa2d4b6f6e41681dec6d6d3693ae1ad5bce"
    sha256 cellar: :any_skip_relocation, big_sur:        "1034373e3c52bb333d77ea8b2906593a4f30f350c0da7692cd90196a45b1109b"
    sha256 cellar: :any_skip_relocation, catalina:       "e20e87b69bbce5770e616274ccdfc423906cfb5e53ae7636dcc90128edd16aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a92c834be63b3db73d6246de6a85cb308d329733f0264437eac68f4083a16a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

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
