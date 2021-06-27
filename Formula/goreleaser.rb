class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.172.1",
      revision: "32a44ab928879bb32c1e266b80de32e07d5d6721"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ac06debc1ef04baf900e1300cc7cf7939e9ddfb81b2121f101393e5143a7101"
    sha256 cellar: :any_skip_relocation, big_sur:       "4f1c7da458bd6f1f4d1716c1cac0b34d5067e7bd5dcb8990179b842029968578"
    sha256 cellar: :any_skip_relocation, catalina:      "5baba40bb52a0b0d7572a540f2e5684c96771ee7e12d8683106ad0340e7e01bc"
    sha256 cellar: :any_skip_relocation, mojave:        "98428db8b44e332776f198cf70c616679a63b5cab644969a22094990e5ea99dc"
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
