class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.5",
    :revision => "7cf1056d1acb9fee781312126371c69bf732ab59"

  bottle do
    cellar :any_skip_relocation
    sha256 "5aaddb57a6bace059477f95cf4bf71648a2cd6b5b0854395bc86a206caa177d2" => :catalina
    sha256 "2b1e2a6d68a8de089ad26a1bfac04b594fcec468212161f408f8da0acfcafe86" => :mojave
    sha256 "f86580e7cd5e2d4e698ccb640fa46f9689e730ad22707cfeea8f0cea93a9fca4" => :high_sierra
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
