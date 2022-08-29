class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.31.3.tar.gz"
  sha256 "1eed7e948cbe5a41963cd8c59caad49c54d043b662dcfe45a9f1a6a88e52a111"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f75742e8fc5d90311a460b1a983692f78ff9fa267210330d469cd0d63e885eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac565e102c3cfd79510228333a3268d5de21834ec5b20ec00ca507cc24760198"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a652987e9bfeccf712761b0083c42f9a25b6d6fa185c40bca9153981046996"
    sha256 cellar: :any_skip_relocation, big_sur:        "434119d4fa650ce2294269ee8883fa982255730672bb31028e16840a3c35c323"
    sha256 cellar: :any_skip_relocation, catalina:       "a1eeeb0c48f5e75f3b5180cfc5a6b0bece0615fd3d28002871108c2d5710c49f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7f8b4231f7adace27ba2a897389452b56260a3677f101496bd474e67c71b207"
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
