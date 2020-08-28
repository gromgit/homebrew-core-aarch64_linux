class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.37.tar.gz"
  sha256 "f2edb63d510b2efe12e3a71c52f83484d3f02109668523f90ee35490e272c7be"
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
