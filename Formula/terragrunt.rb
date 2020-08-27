class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.36.tar.gz"
  sha256 "09c0fb393502efec9a2b20788f3b1a22cda96cc169b0c88ce90286717add1113"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbcb601d7ed399ada2778d2d05661944dd87a481349714d6870e02589f0c9198" => :catalina
    sha256 "46ea01d594d0f4e41014f32b32f02c3b1b59aef952057c13d9d986d5d1e32459" => :mojave
    sha256 "89e9a1ab362aefcfcd691f70d52920011daeb4d65cf19990c6db35b744cff287" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
