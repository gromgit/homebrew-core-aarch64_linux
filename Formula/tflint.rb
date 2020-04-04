class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.15.4.tar.gz"
  sha256 "3378055e8f1591c46d313765b4579d7484612ce88bea5222e5d0d14f4f8e5cef"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58976860388a9495c0edab0404941132192233ceb6b3b7c9781717920e2116d4" => :catalina
    sha256 "195aafb52ebeddb949b28aec9c22397d0fc13de005f09e30f173dab4faf916e4" => :mojave
    sha256 "2d3378ca0b19c0b42384c60f63ae35d1e8b76596813f1cc621d83ab894cb3ce3" => :high_sierra
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
