class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.24.0.tar.gz"
  sha256 "f3d4d731d8a73f6eea60ac5e69675a9493a9b846f9de4884e38c4fbf9d10db31"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7971597036bb661461d944414c0ad57f6ecd005c78e75648bfa72dd33afe253" => :catalina
    sha256 "29e4c16ec29e6afe0792b6f815a0fb1f1f353ac41d316a5de3a626d381430938" => :mojave
    sha256 "6b2c30e8da3303d70f3e7514247682f2148c0e277f2f769714d8a1c672b04870" => :high_sierra
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
