class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.21.0.tar.gz"
  sha256 "b93c08074be5cc12700863d5390b8f255399ac758b75dcf365b9a10ec456b47f"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81e321f42ed96a708a46e2357cf40615aaabed4e16c2b43128a200bcb731bd59" => :big_sur
    sha256 "44faec0b99823848eff45b257d99edfe975fb96483d61b58309d84adc9026417" => :catalina
    sha256 "e535f4338069430281760112565ee745b4cebb1db4ccf661fd09e07aa2926ceb" => :mojave
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
