class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.8",
      revision: "92c8c7a2da9ec90a924d7236e540f83ec1f12419"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7e93e1d73d9708b19447a3e886f5de88d8dc2d4b81e5146444682f341bc9b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b7e93e1d73d9708b19447a3e886f5de88d8dc2d4b81e5146444682f341bc9b7"
    sha256 cellar: :any_skip_relocation, monterey:       "a258cfd3619e3ac4c9090896d35d3e085596d8098a3602ca0b5bc825307c3794"
    sha256 cellar: :any_skip_relocation, big_sur:        "a258cfd3619e3ac4c9090896d35d3e085596d8098a3602ca0b5bc825307c3794"
    sha256 cellar: :any_skip_relocation, catalina:       "a258cfd3619e3ac4c9090896d35d3e085596d8098a3602ca0b5bc825307c3794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fbd68e635c5a3ebec261c274a25bdc3a969d51bd6eaefeef53326dbf133fff8"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X go.dagger.io/dagger/version.Revision=#{Utils.git_head(length: 8)}
      -X go.dagger.io/dagger/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    output = Utils.safe_popen_read(bin/"dagger", "completion", "bash")
    (bash_completion/"dagger").write output

    output = Utils.safe_popen_read(bin/"dagger", "completion", "zsh")
    (zsh_completion/"_dagger").write output

    output = Utils.safe_popen_read(bin/"dagger", "completion", "fish")
    (fish_completion/"dagger.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/dagger version")

    system bin/"dagger", "project", "init", "--template=hello"
    system bin/"dagger", "project", "update"
    assert_predicate testpath/"cue.mod/module.cue", :exist?

    output = shell_output("#{bin}/dagger do hello 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
