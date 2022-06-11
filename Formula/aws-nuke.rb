class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.19.0",
      revision: "357aa44f5a04df9d1faa8c57bb5ce924871a910a"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aws-nuke"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c9aa1d7b31a4f20172891a2385c010b547fc1fe1e3bad5da62adc1d03721e386"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/rebuy-de/aws-nuke/v#{version.major}/cmd"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.BuildVersion=#{version}
      -X #{build_xdst}.BuildDate=#{time.strftime("%F")}
      -X #{build_xdst}.BuildHash=#{Utils.git_head}
      -X #{build_xdst}.BuildEnvironment=#{tap.user}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    pkgshare.install "config"

    (bash_completion/"aws-nuke").write Utils.safe_popen_read("#{bin}/aws-nuke", "completion", "bash")
    (fish_completion/"aws-nuke.fish").write Utils.safe_popen_read("#{bin}/aws-nuke", "completion", "fish")
    (zsh_completion/"_aws-nuke").write Utils.safe_popen_read("#{bin}/aws-nuke", "completion", "zsh")
  end

  test do
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke --config #{pkgshare}/config/example.yaml --access-key-id fake --secret-access-key fake 2>&1",
      255,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
