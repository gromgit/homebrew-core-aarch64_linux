class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.30.tar.gz"
  sha256 "e86802fd4c85d942b205f508c607071afd34a0e03d4e0d883c0228252805a24d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf8d9e8070eedf0b2628ddd033c67f6d0b1775ba5f7a7621dd1ba1d4baf7bde3" => :catalina
    sha256 "c268597473dc7b086bfe740600dd5e76e57ed065b1578d364b469a0462e84350" => :mojave
    sha256 "2601f8dfbceba87cfe69e181dea647901bd990195f2c25dc67d44b34073285fb" => :high_sierra
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
