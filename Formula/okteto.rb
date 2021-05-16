class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.12.tar.gz"
  sha256 "32a88432fc028ce389e06d97f89d8ddcd79d94f7e762c990f3ec7ffd0b74bf3f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f80d94ac2a2263542dc37b192dcaf423754984cbf5531cb03ba74b16996b873"
    sha256 cellar: :any_skip_relocation, big_sur:       "33b4c43e30ee61f3e5266945ce37f0143df8d59f62468e096461782775c7f173"
    sha256 cellar: :any_skip_relocation, catalina:      "ca31ae6407ac952966612a511378174655560562fd2391227ff98c48e5fce39d"
    sha256 cellar: :any_skip_relocation, mojave:        "1c8bb6274191261f5ea020bd99153b4e3de1dcd00997febe350d4f0e3d8797c2"
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
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
