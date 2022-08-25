class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "b0077fd4408227c4b5509971a220fd4ae5d8bec1b05d340503905a6dae306fdd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1788c3bdb18841eb0fc1d645ab1c32e39cfada98c3e64a7b767d33bf5ef1f084"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1788c3bdb18841eb0fc1d645ab1c32e39cfada98c3e64a7b767d33bf5ef1f084"
    sha256 cellar: :any_skip_relocation, monterey:       "d8d8d02a50d7a8caaedc26ede6a3e8b27d6b54b9db21fba0ab9a2e567470349e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8d8d02a50d7a8caaedc26ede6a3e8b27d6b54b9db21fba0ab9a2e567470349e"
    sha256 cellar: :any_skip_relocation, catalina:       "d8d8d02a50d7a8caaedc26ede6a3e8b27d6b54b9db21fba0ab9a2e567470349e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72ff7bd0c8c04c0a28d14974a8282f7c6d887b93768c3f718aac2fb28e8c850a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/railwayapp/cli/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    output = Utils.safe_popen_read(bin/"railway", "completion", "bash")
    (bash_completion/"railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "zsh")
    (zsh_completion/"_railway").write output
    output = Utils.safe_popen_read(bin/"railway", "completion", "fish")
    (fish_completion/"railway.fish").write output
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Account required to init project", output
  end
end
