class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.26.2.tar.gz"
  sha256 "f58d9a1bba7ea5821d4b925d58c426fe3b26b39542f7eaf7cfc03aeaa71f6328"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f9683e55ece9849dee9526041e1cdba40ddc145e5d956969db208352413542f" => :catalina
    sha256 "cc02b907221820cd00e5032141a618e66d948e0e58dcaa934189b2c540ca0967" => :mojave
    sha256 "b2ea56792de7d6141bdf4ccfaa6c951672b553174120c59006ca71d23049fb10" => :high_sierra
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
