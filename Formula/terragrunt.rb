class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.19.tar.gz"
  sha256 "d9f656a4c95d6c68217c7afef468f4c59d19dc7428f7b48d4c77092b10cd3b3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d463c77d1678f5d28f9d683e2246236250e0a28108f0f9ac9ba34aab0bc3ce7"
    sha256 cellar: :any_skip_relocation, big_sur:       "edc9c4437684e82b5c9e82c670c39f4edb29c7fbe9fc4d41c10fbef1db33e235"
    sha256 cellar: :any_skip_relocation, catalina:      "cdddabf9f50c5ddec825383eebacbcdc7df80d4bc1ad386c6d72a8e419291495"
    sha256 cellar: :any_skip_relocation, mojave:        "94d280c39f10ce86de9b10ab4afd0ce2e34c518853d1e20cfe70a43f7e38c8a5"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
