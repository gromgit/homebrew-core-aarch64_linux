class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v1.1.9.tar.gz"
  sha256 "a22d539fc18998ff62bccd5aa74fabccb4f402073d3c4a1a2840db2f428f9b96"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94cbe9a25c0a856b8ba554db1a7a79acfc08a545e13a1c86b7faa582d0ace7df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdd424be40f690cf0b0f84626be96343aa1134962b876d48670c1726fafe13b8"
    sha256 cellar: :any_skip_relocation, monterey:       "5a6eb79befa8a59072ce96df31d017282faa3ec9bd780bc08ce06d234c9638a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1f7b8cdd8c9fe1628cfc53617023d7d1088d23e8935f246499e874172f8444"
    sha256 cellar: :any_skip_relocation, catalina:       "113cd074ce9401323e46a456937cbd47145b581caf3a9d2afce1f4ce534a4ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa28c68646a884958510640071f2fd53ee60ea4d388777134eb5c1bdeb72f9d"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

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
