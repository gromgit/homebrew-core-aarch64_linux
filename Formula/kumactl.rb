class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.1.5.tar.gz"
  sha256 "7db7eb5ca8e429d1dccd076aa257d901e9ddeaa66d69af30a60ddec1722d013c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9233d1b17c0792a62ef60155d9a8ae5f8aadb7fb048faee06c7ef42ce747c816"
    sha256 cellar: :any_skip_relocation, big_sur:       "61b0a2e73ab791408205c991bb785fcfac6322672509114bd8998f7cdb2edf0e"
    sha256 cellar: :any_skip_relocation, catalina:      "ba48aff7ef62800c99f722f95711c576cf3bcb7e43d54751e80e69a7fe61d3ac"
    sha256 cellar: :any_skip_relocation, mojave:        "af1082eb473a07722c876b31447a65f3d7d8921c377c9138ca8e352694528720"
  end

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl", "BUILD_INFO_VERSION=#{version}"
      bin.install Dir["build/artifacts-*/kumactl/kumactl"].first
    end

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "bash")
    (bash_completion/"kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "zsh")
    (zsh_completion/"_kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "fish")
    (fish_completion/"kumactl.fish").write output
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
