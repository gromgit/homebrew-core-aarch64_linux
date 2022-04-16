class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.26.0.tar.gz"
  sha256 "44ce2720b3fd99a20dc0a2de7d942c2217bd44d762402dbbdece3dd3d1f5fce5"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e5fa38f064a116f5c45558466f27b7a7ba4589ec68ac65490d1cac0a845e244"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "339e984de045606a59748e6e9c7455d2fe08f070690fb7340c1ce9318338b088"
    sha256 cellar: :any_skip_relocation, monterey:       "34c0958cc9a96ecafdb93d14561b8b5e2869d0e102e5cd93ff90f01a8360d35e"
    sha256 cellar: :any_skip_relocation, big_sur:        "38eea5c3c4dd4513fb8bb8747ab933b6f640630dbbc1e9ae3c15310bcd69257b"
    sha256 cellar: :any_skip_relocation, catalina:       "785f232217970cb07a7af1d170a0bf0b57491539cd9d1ff9e5e63aef7575cade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e566accd727eb02aa9c08d8886e365e6a711ad12f22381010024a3a7dd8a798"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
