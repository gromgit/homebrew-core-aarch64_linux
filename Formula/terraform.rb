class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.0.3.tar.gz"
  sha256 "0b746b3464aeee13bfca8872123574be56309207920347b6e00f665ff4c8b402"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7e4b0631432fcaa5b8bec5c05f46de8bf758dbf0d0689fc197eb976f77c977d"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb38f9ab3d5246b6c64803f929bb88a95207b71bcae67234e94131b2ef303b0b"
    sha256 cellar: :any_skip_relocation, catalina:      "86350749011000916becbb4001b635489bbb30675c854fa495af72b64497aa53"
    sha256 cellar: :any_skip_relocation, mojave:        "68c738723093de490a99bc3551157f9d8ae1fe15d41e27978fa2b625506c1ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aad49bcb0f93c62c8fb2eabc0b5ec7142d7fe6b0e6a763b0d81a42b92162bc9"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    # resolves issues fetching providers while on a VPN that uses /etc/resolv.conf
    # https://github.com/hashicorp/terraform/issues/26532#issuecomment-720570774
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end
