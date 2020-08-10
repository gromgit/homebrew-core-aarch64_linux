class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     tag:      "v5.2.6",
     revision: "5b1f02259660a71f7bcfea6567ef44cb2651a34a"
  license "BSD-3-Clause"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74ac4f690aa0580d8d1b9d4f5e2ebf345bc93a6769a3385c1978df1c223a6c2d" => :catalina
    sha256 "5735c0bddb932732eb75032380d408a92f614520b985faee55ed2d00daf5d4a7" => :mojave
    sha256 "31143675cbccc8e2eff06e482a65a720cd659aedd455a646679aec996be1836d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "virgil"
  end

  test do
    result = shell_output "#{bin}/virgil purekit keygen"
    assert_match /SK.1./, result
  end
end
