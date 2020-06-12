class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.25.tar.gz"
  sha256 "9f6e2fa677cb39319c3f474c58f3013ba0f49acf8a844b422ebeeea01f7e0b2f"

  bottle do
    cellar :any_skip_relocation
    sha256 "235eed2753c8f68aaafaaca3d6d74f0623d505b2560a9d0d5ec9fcf57bed6433" => :catalina
    sha256 "db0dc5df191256b88502cadc64fdfb57e6644a2822bd542fb6886895dc4f7845" => :mojave
    sha256 "7effa69ed6e137d8cbf57037005ebce3db8361adcca89c86d572721a73a20938" => :high_sierra
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
