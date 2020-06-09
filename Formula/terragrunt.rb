class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.24.tar.gz"
  sha256 "839657476de3a8e096381e2fa4379feffad942b28b484336b8e3a48e6090a042"

  bottle do
    cellar :any_skip_relocation
    sha256 "a032752d893a2be4c7ade05fed422146c879a5cd4bcf69c8bee4489050ee7244" => :catalina
    sha256 "44d9ee3cd35d32a1dc33fde30c3e250bd0ac8c92ad6b99451dc2df3c785f59dd" => :mojave
    sha256 "21588d35f03ccd744d7c4cea52c5e44e34f6a8830d23710bf95965f04280cdf5" => :high_sierra
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
