class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.7.6.tar.gz"
  sha256 "bc2361718cce62fb799f8470a268b9d2af7ab95a8337bbaa05d79f4b636482d1"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82dbd1e4c57f25572b75908f6a09b5a1b0e84e3c3e516a36973ce81533ff0016"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86ef36d8df4723124d98d2830f28d5a482fb1b56eb9a46b31baf360067eb59b7"
    sha256 cellar: :any_skip_relocation, monterey:       "c710168c4ea588941c8a4f5456129757de5cc9153e63b664295dc02c76af9738"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfde0634cdba8079c0a0747d196c3f480e7e7e9998aafb6f3aa597312a233069"
    sha256 cellar: :any_skip_relocation, catalina:       "c01846361000324615b5c6059b6c32c2128e14a3007a61b2abfe23e11d8d520a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd0bfc5c406ff821e00036abeee18fb22820a2380515ad8b67b3b284bbb0fff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/cycloidio/terracognita/cmd.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/terracognita version")
    assert_match "Error: one of --module, --hcl  or --tfstate are required",
      shell_output("#{bin}/terracognita aws 2>&1", 1)
    assert_match "aws_instance", shell_output("#{bin}/terracognita aws resources")
  end
end
