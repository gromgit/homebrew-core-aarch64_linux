class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.6.1",
      revision: "133d7e769491ed802f3d0bed68338d74357f6159"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "874ebb925c04d86a733280e3e6dbf1fac3cd174490d92906d6aac0f2303b36d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08bdd01d1fe3be0716ad5eac56a0acc6010df4f18d3e431e46a003ea9da13144"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42810815b6b64a65046eb3cda9691ce2247e490a278a7a88edd8bd1c44318db7"
    sha256 cellar: :any_skip_relocation, ventura:        "60f552404eaf275a379f1599c2b39fa3f3b348d686a801ba636790f040e9a52a"
    sha256 cellar: :any_skip_relocation, monterey:       "7306436288118bac19f6c668531de621fc33ca1602be7d572e4e48cf8b9a4fda"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2b568d01aeb0268d2d2bb0748c97ca82a72f965ea6259146916fabaf583e80e"
    sha256 cellar: :any_skip_relocation, catalina:       "5029a21da509d8f366d3e8d8f5dd922cf631b2ded5d9b762755218e31e50f969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61ffcfacbe3104d07215514252e0b1a16bdbcee245bdf9d14092f8f7e1a3f9db"
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
