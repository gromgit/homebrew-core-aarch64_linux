class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.12.26.tar.gz"
  sha256 "4db5deb8c6a81956bf603196a1300aacbe80dd5716244ae20c2f9b3df571df4e"
  head "https://github.com/hashicorp/terraform.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "be7faa7a2a3670e67f4bae317318b2cfe47fda55ce79537c33744d986acabd9f" => :catalina
    sha256 "be7faa7a2a3670e67f4bae317318b2cfe47fda55ce79537c33744d986acabd9f" => :mojave
    sha256 "be7faa7a2a3670e67f4bae317318b2cfe47fda55ce79537c33744d986acabd9f" => :high_sierra
  end

  depends_on "go@1.13" => :build

  conflicts_with "tfenv", :because => "tfenv symlinks terraform binaries"

  def install
    # v0.6.12 - source contains tests which fail if these environment variables are set locally.
    ENV.delete "AWS_ACCESS_KEY"
    ENV.delete "AWS_SECRET_KEY"

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "-mod=vendor"
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
