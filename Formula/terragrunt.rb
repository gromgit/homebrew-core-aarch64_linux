class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.6.tar.gz"
  sha256 "c9166789a1645f5595e4ea4f56ac9fbaa0087e8bbc4d80c6913325edb4e05faf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9b0741d22c1bd1e40b1388ca49898d9e8f769d0ccfc31072420bf05fd26a0c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef94f0aa750d859dad56e299b1b504a273407debeb88f24fc619dfb866b6a781"
    sha256 cellar: :any_skip_relocation, catalina:      "e5bd3d98659dc186bd315c58288982d76297ed0fe52f071dc006713be0a9f966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60cb05a05eee7c2a6650003c25509a0f03a8c7460258b01d58de3b9c910f6191"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
