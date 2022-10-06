class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.8.1.tar.gz"
  sha256 "ceb22fa7d3b5a56a6f963b6306c7224211ec957cd11544c2cf7408f26718bea2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4adf2b7115a278a7e650959347e6459d6f9843316bc2275062d40da6daf5baff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc9cb3ea61086b0a260619de9b4a626bf1a309b25f8b89b86f9e70565466fdbe"
    sha256 cellar: :any_skip_relocation, monterey:       "5a65966a1ce501feae6903af1f10f2a10b7efff7480e4183bdea9bd1f62a0fd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dc3265d87c5c68d72f6d7f311bc57c2aac4ebd50500cf24be51d74831b30e22"
    sha256 cellar: :any_skip_relocation, catalina:       "ed27e008739b293b2bc1ce0ee59fdb2fcd8d6cfc6a36b5717207de8e33101ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "377939feec85b7ba5b4f493016c366e6338f5a00dc4c509c219911edccce80f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
