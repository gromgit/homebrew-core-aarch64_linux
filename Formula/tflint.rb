class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.23.1.tar.gz"
  sha256 "aa665fda9377514f4fcf4c72d5fdde8d02027fc6d2283074ad2527e2df5779ed"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1ed06ee9bfdc3aaf1b21c4eece49f5a7dc5ce6921dc824ea689891d9df3b4f7" => :big_sur
    sha256 "8fcacafec467d63624f7110b44edf5ba56aca04219ccd66bc2487f8f48f9f661" => :arm64_big_sur
    sha256 "5510a2e0c7b4d1bde2463601abde0a97f78ef1d2f9f0cb69fbcfeac5b765b398" => :catalina
    sha256 "57429ef99fed30fdc9b5f8433e5cfb6c349d040fd73ba6c827601618541fe6d7" => :mojave
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
