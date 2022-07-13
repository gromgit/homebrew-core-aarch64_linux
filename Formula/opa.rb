class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.42.2.tar.gz"
  sha256 "f96ca3c985c50c2c393d0c914a9ec22f7ed4a21f1948094b8161319ca63b1625"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f04959c8b3eced9ba9b7f5dee623e3c45653b6de0adf12e19f319aa99aa7d85a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fb89924860152feb7558642ac582bb246fb380a2f8837e99dc713fceb83ef81"
    sha256 cellar: :any_skip_relocation, monterey:       "c31ad0577a52ba83012f85eb8594aa7d0768a1ef4e51d9df8402f931e8d6af8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c9969ccb0a249a733c2d33860a00e2f0d0c5a6ca2a358d946afa641a0ebdbb1"
    sha256 cellar: :any_skip_relocation, catalina:       "33c2c0f4020645827485f1287ba0be4f86f5c7058a96e9ccfb8464cc33b41a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0d734a2f89039f36965a6cbaecb1f1ca8b1ba42c3e3d79e29ec30421e7b4d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    bash_output = Utils.safe_popen_read(bin/"opa", "completion", "bash")
    (bash_completion/"opa").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"opa", "completion", "zsh")
    (zsh_completion/"_opa").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"opa", "completion", "fish")
    (fish_completion/"opa.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
