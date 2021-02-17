class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.6.tar.gz"
  sha256 "f4100c9209f1ccb29ee31cea82158066cb5505d55d1be2fb14258b1e428d0866"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "cb47d1b8edbc7eef16b620878d887ff33ecb5cb0b0ff5054b599d0d4c48fe7b8"
    sha256 cellar: :any_skip_relocation, catalina: "ab0cc16c1e719d3417e3ed2b561164282ea1b5a2525f1f405189aac17ddb990e"
    sha256 cellar: :any_skip_relocation, mojave:   "f0abb20878ba4b1c9136861c437ca099cc9c993ac4e7f0e65cbc0ea505851f90"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
