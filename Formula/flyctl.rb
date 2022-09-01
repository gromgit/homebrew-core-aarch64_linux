class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.387",
      revision: "d46c14f3ab0215de43098f1d40aa5279d85b5d5b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18680fe8cca0900a6c048a50ca03488d9e3c39911bcaf81e2199be5f56ab9427"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18680fe8cca0900a6c048a50ca03488d9e3c39911bcaf81e2199be5f56ab9427"
    sha256 cellar: :any_skip_relocation, monterey:       "1f8c3612c3ff76489afb4fbb7798a0bb52b2529d3108cf1fd6c16161e6eb7e66"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f8c3612c3ff76489afb4fbb7798a0bb52b2529d3108cf1fd6c16161e6eb7e66"
    sha256 cellar: :any_skip_relocation, catalina:       "1f8c3612c3ff76489afb4fbb7798a0bb52b2529d3108cf1fd6c16161e6eb7e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037459dea22504cd6146a42bbe45220960fabe64dacdf01d19f1e984d15ef7c0"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    bash_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "bash")
    (bash_completion/"flyctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "zsh")
    (zsh_completion/"_flyctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "fish")
    (fish_completion/"flyctl.fish").write fish_output
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
