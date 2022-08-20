class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.3.0",
      revision: "bbcb5aba76d966f60c76629301d0e2cac4ee09b7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5a281a1d3d77131182f54f1b14899e177cf24b45f38173f76195ec6825238a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e816b1f3e0879997b5d869a2a8300b585891bd2f36321fc48e03ccf03de39b"
    sha256 cellar: :any_skip_relocation, monterey:       "ce6a9313cfc0b065290b61a0d8f6a3119567e4516357696a421136ef52c961f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb6b5f6bd72e04b2daa495039e184b42d641f29f95b929740444798e7c549a6b"
    sha256 cellar: :any_skip_relocation, catalina:       "4d64c6ad972529b000234d55ae9da08f8e1d2f977d3da139d5d4f0c18d9648bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5daa668cfc8446280c7334b8dd85ce8b17d1946cef26c83beffe0921fc7c40"
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
    working_dir Dir.home
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
