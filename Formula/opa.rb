class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.42.1.tar.gz"
  sha256 "390f6e23ea789144c4aaa358298b15583ac0b8f6f2dc88872397cd8ce0f6c27c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a485ae53e0964fdca7e2682835717e59e7a79b72eb561a8ef311c0153820c9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e94b47c43b3dbc556b6a4d4bcd255f85c568363da081349774153176c0b0ba2c"
    sha256 cellar: :any_skip_relocation, monterey:       "659b01101037c21e2280d518793785403ddb33d7ddf7af805bd2cfe2815e4bbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ae241df6fa622107331f7888e1a2e2ac81847cc1f39b3d6487662d70dc31326"
    sha256 cellar: :any_skip_relocation, catalina:       "30fd6aa598a6e7bccd2db7e014113c698f24a8d6308e442512b143779415232e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e510594b127f8b8a9a759f03d91f66605679b8fcfcc10e58c691b7d8389dc27"
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
