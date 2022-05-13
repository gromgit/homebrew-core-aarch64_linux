class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.15.0.tar.gz"
  sha256 "a7dcd9481903df150bbd9696bb3f91c4d9b645e8c2dc1124a7ce9ffc551eed31"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70faa89bfd032ee416fbe169defe8bfe5fa6b16c9631818c0faccfe1a3191b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3009304b8200262a603111147172038132840339738c6c5ea925d4a1361c822"
    sha256 cellar: :any_skip_relocation, monterey:       "7f233c3c85f91b7c1eaae9a091241809136f9dade8d937bdea128890409d3a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e7e0f6cfbd6ac0419fc8c25bc739c16dab3d3150233a848fede5427f6ce19e6"
    sha256 cellar: :any_skip_relocation, catalina:       "04cfd04912a6a5842e9d336b4884dfe198f136f84d5199485583940688d5883e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87849071e4f38a979d7b1d40315a45211d65ada80941e98e81bccc973205406d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terrascan"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "/dev/xvda"

        ebs_block_device {
          device_name = "/dev/xvda"
          snapshot_id = "snap-xxxxxxxx"
          volume_size = 8
        }
      }
    EOS

    expected = <<~EOS
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    output = shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")
    assert_match expected, output
    assert_match(/Policies Validated\s+:\s+\d+/, output)
  end
end
