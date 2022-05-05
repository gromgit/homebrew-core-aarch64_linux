class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.10.1",
      revision: "f761588fb6cdd543ba702ba94c5ab5f102170117"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e2b596c6d479c431753ec81c13460a72394ae3279acc06bf9a670e9540f0f25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33300fe4f56c96893fc59b0672bbe82f84123a839b84bb29848ed866cf0baaef"
    sha256 cellar: :any_skip_relocation, monterey:       "2a80f289cd3224c9eaede4716f7f06ca4b396ae78af1e65c63b2276a65ed0f1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "caaab675fad7df55e758b4b16f1563cccad4732c396cf775db90df8618fcf6d1"
    sha256 cellar: :any_skip_relocation, catalina:       "a7e0bedbf11e2944eac06481e388a9ce3643b4dba91e7c82dec7f60b52f9f433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad76e489c8be01b275e91ce8f7e4acbb35dcb1ff3e6893197e12e1c2bc5eada9"
  end

  # Bump to 1.18 when x/sys is updated (likely 14.9).
  depends_on "go@1.17" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir ENV["HOME"]
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
