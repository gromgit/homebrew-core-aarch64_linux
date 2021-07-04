class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.173.1",
      revision: "d246b1b608128e05bce7df5144f370e35667974c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae22961166b97f178734724dc4fb37933ee37797409bec90bbc0e5cac1455d88"
    sha256 cellar: :any_skip_relocation, big_sur:       "d07dc4a829e417dbabb3cdab35e759a264944038a4ac45ad50a52cf62f171ed4"
    sha256 cellar: :any_skip_relocation, catalina:      "505e618ad06e6ad4f4b998f8ec0671ce9a9816a72d26385a704e91601ac75913"
    sha256 cellar: :any_skip_relocation, mojave:        "582140d32b0ae37be4908b3842667569cc43246d677922871ceb464a9b40d36a"
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
