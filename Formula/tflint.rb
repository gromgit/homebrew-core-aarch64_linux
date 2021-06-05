class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.29.0.tar.gz"
  sha256 "b5b40f1b54a70cbdc235828a271da1df96fc5da1527e4579a4d007c5f559c26d"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52be2ad0cd9a4ad30ef0217e70b8601966cb2ccba218d5e604e047fbb2a287d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e2c1ad51d7c874816cfe604e7523fdca688c4ae74b0eeb2c9de06e560eae5d9"
    sha256 cellar: :any_skip_relocation, catalina:      "25c08271f39d5a2fa83827e75a877617ca9befd51d6c5f7b8287f3a45113d311"
    sha256 cellar: :any_skip_relocation, mojave:        "3e617b301a4bd02e052279a8aa168a97ef27cf0b3b4a2f30ee59833e96548a2b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
