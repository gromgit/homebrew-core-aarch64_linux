class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.8.7.tar.gz"
  sha256 "2e2b027beb59c44a8ecee744d08f3c02f0d97fc07e5fbbf9d6f30fdb1c290992"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "510949aae7a2dc735ef19421b5489a1ea29fff3b7c7405e4f95c9881f3c91734"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7e71e0d6be712b547ea364f3928312217789a92d59694564a21e8cfbbe08a09"
    sha256 cellar: :any_skip_relocation, catalina:      "e7e71e0d6be712b547ea364f3928312217789a92d59694564a21e8cfbbe08a09"
    sha256 cellar: :any_skip_relocation, mojave:        "e7e71e0d6be712b547ea364f3928312217789a92d59694564a21e8cfbbe08a09"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
