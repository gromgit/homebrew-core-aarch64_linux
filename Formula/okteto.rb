class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.11.1.tar.gz"
  sha256 "146e94eff3297b6fc9289530ebe2b8b667861c01f1fee6957df5baac3f09cc44"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91aebee9311634d059e6fd0e41b121143cdd10062e9c07cc9e8a9c90743a3ae5"
    sha256 cellar: :any_skip_relocation, big_sur:       "da6d2888d29f7f90344e45bcf7ff4c0e430f69a99e1f9607211f7a7a49f6d6df"
    sha256 cellar: :any_skip_relocation, catalina:      "18d224d4d6e5e5cba69fc38c7312dfe7cce5bceeffa69d2d453df1676c3d5afd"
    sha256 cellar: :any_skip_relocation, mojave:        "ba7976e200a7f591fbbf44ab749966df92b337d2176186581de86d8ddfe19c42"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "error accessing you kubeconfig file: invalid configuration",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1", 1)
  end
end
