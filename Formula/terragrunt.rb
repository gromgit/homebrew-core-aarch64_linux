class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.31.3.tar.gz"
  sha256 "275aa436f29d0a86c99c1c4bcb12c9fc416657994e26ba56130c9bf37d7a84ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97a2c889f3383d515d2b3531433e539294abf5b728149aaf964ae22cad7c8515"
    sha256 cellar: :any_skip_relocation, big_sur:       "19f33aec3b54a405069b44cc45a632d8ed9998a71bd03de8ee538f27628cebd3"
    sha256 cellar: :any_skip_relocation, catalina:      "b7cded4af9f43d898da6d3b075b0623f877c96a02d8242c230c728901f847327"
    sha256 cellar: :any_skip_relocation, mojave:        "37554cb189ad496be42d7a8de784819d6935f9b06eddaee3bd0c8dc53e3ceaef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d920d174e1869e325b07db4c75c659999e4015e08966b37ad4b74e9f2d1781cb"
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
