class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.3.1",
      revision: "8b63c432e32bdc71a8641afe783000698610e528"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "535ccbc734817b038e531bb90dbdc15ecb6f4414186b0b35fa8109fbbd350c11"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba54124ebdb8ec521f7c745d23fe7bd24ed2762880c8c373b773b9b10e9225d3"
    sha256 cellar: :any_skip_relocation, catalina:      "46b51fbd2859d1c43a0ba6063ab8546f9b66ba0c8d42e8762387d244aa41dc19"
    sha256 cellar: :any_skip_relocation, mojave:        "e05aa52fff231b427327a4ee34d9b899a5192b21de234fb7a0467f3f81de75b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9bf64f9e2e8c0792ae9308052c3ebc16f5fc0678c848890b42835073b59ec58"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir ENV["HOME"]
    keep_alive true
    macos_legacy_timers true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
