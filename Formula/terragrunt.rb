class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.21.tar.gz"
  sha256 "9515bc4f364b60a819b2933778f0f168c5fba0aec7a8959bde03a9e74b84bf3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "662ef1129dd884a39ffe114135662edd01bc3c97bce00952745ab06759f83901"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcff8ff1a8b345222b60fef073830eb2335f7875aa912493c3d674d87322fda2"
    sha256 cellar: :any_skip_relocation, catalina:      "1dac34b327eba4bf033858492269425785d3e03e68a64911b70393bbca5bc773"
    sha256 cellar: :any_skip_relocation, mojave:        "33234973c6aeb9816a704fbf289b58a2de058a3929204e1618a052900f53cde4"
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
