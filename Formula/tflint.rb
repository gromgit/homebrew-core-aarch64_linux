class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.20.0.tar.gz"
  sha256 "c723fd78d2482ee5a3165b725c423fa2c6163bea9ea7206aa1d496b7abe9d8e5"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3cd817019d6159cc1affee6e97094ea86f6f84e51864b6f39a1f4481faaf014" => :catalina
    sha256 "8c2a3bc2ed0b958bdc506d16c67fdcd7bd8c28dc128283c0c436069d3473fff7" => :mojave
    sha256 "b85e3dc11ada496d6bd72f035fa3be6d967cc3c0270d30af83738f87c1400ed2" => :high_sierra
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
