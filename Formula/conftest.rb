class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.32.0.tar.gz"
  sha256 "7e2bd2ae486d72bbc55e3ba376336fb55df62f3453ad45fcbcff3dbe766f9925"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "877b81c02bdacfd2b6f21eeb237aca75fa8ff881fbce546881eafaf26ae64bf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d6bcf08d7ff0b3ddb93fff86727aa711ec463823937a020ef1c2f03a2d79766"
    sha256 cellar: :any_skip_relocation, monterey:       "5af2c33b8ad08e83f6bceb5d86e50661cf8d6f2f270c0c7cfcb43012f0478107"
    sha256 cellar: :any_skip_relocation, big_sur:        "985ca3d0bba96b7bdf8bea5addc36df2ab3288a5c1c0ece59a748a343849cf09"
    sha256 cellar: :any_skip_relocation, catalina:       "4caa8233a192307b83be33d2fe5027d5383d75f759747254c8ef8a6c2d4111d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4854a67ab7a5a2c5ceb78ac55b5625b57c3fa6119915b996be9b3e29ab70e9f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"conftest", "completion", "bash")
    (bash_completion/"conftest").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"conftest", "completion", "zsh")
    (zsh_completion/"_conftest").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"conftest", "completion", "fish")
    (fish_completion/"conftest.fish").write fish_output
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
