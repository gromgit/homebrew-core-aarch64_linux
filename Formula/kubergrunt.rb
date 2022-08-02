class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https://github.com/gruntwork-io/kubergrunt"
  url "https://github.com/gruntwork-io/kubergrunt/archive/v0.9.2.tar.gz"
  sha256 "7e7ec360c78ebfc672593d66766e387f95d5a7807e79d13298efb9e0128feb61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68effe374818b5c91daf501d1c32fd985d2fdec644e7d8bb9a3d1fb9c0144f86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7810095334d4947510d6df76df7d3c9410c78c5d66b218afe38b7c153f244abe"
    sha256 cellar: :any_skip_relocation, monterey:       "adb10fb31cbb38e99a9808f94a82c4cd73e115dd9f5eb0ca72f9d077ef6dbf72"
    sha256 cellar: :any_skip_relocation, big_sur:        "03c1017e5d3e1490e40a140167b5eed305728179d16fc10ae0bd69e09d5e1959"
    sha256 cellar: :any_skip_relocation, catalina:       "d4f173ddb23848a1206eec66de95471177c7b4212780611c14d46d43ca8d6a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "782d0bfff784c40ec147bad45fd5bc4c912509d87ef9e6a9543353274e5dd85c"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}"), "./cmd"
  end

  test do
    output = shell_output("#{bin}/kubergrunt eks verify --eks-cluster-arn " \
                          "arn:aws:eks:us-east-1:123:cluster/brew-test 2>&1", 1)
    assert_match "ERROR: Error finding AWS credentials", output

    output = shell_output("#{bin}/kubergrunt tls gen --namespace test " \
                          "--secret-name test --ca-secret-name test 2>&1", 1)
    assert_match "ERROR: --tls-common-name is required", output
  end
end
