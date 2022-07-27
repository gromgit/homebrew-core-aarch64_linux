class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.2.1",
      revision: "32fc1585e5334b1a4c4fd4962a7679fcebaf8f49"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ce5f885a5b63fc56658e2bdb1c25793d56733973e58657c02803cfb24575942"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f78028881999b0f74d79a3471e7a0c922c3360115ad957224f035c3dc3488d7"
    sha256 cellar: :any_skip_relocation, monterey:       "7038d29b13b6e642f7b8b8bf359e513abb136f06818080abfb4be8a53cda7a0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "60c1165eb20db1764525d4b408eff148689803736b4ae9f5c161039d065b05c6"
    sha256 cellar: :any_skip_relocation, catalina:       "eee19e2b81700f9d91738ac05e80de93e3a51e9c437147163a6d9a5edc3e539f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ea825c5c82a07031bb7bb17397f500b8f976e459bf31c9a070715af00181d46"
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
