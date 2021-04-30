class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/v2.2.1.tar.gz"
  sha256 "8de13c82a1e990907ebc52651e13933ea94889aece913e05f6bec76d9516af0f"
  license "MIT"
  head "https://github.com/tfutils/tfenv.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca841a7cdaca4488d09fdee4a0eaa2a1a3cdb5e9837e32183ce0fddbee9d4f6b"
  end

  uses_from_macos "unzip"

  conflicts_with "terraform", because: "tfenv symlinks terraform binaries"

  def install
    prefix.install %w[bin lib libexec share]
  end

  test do
    assert_match "0.10.0", shell_output("#{bin}/tfenv list-remote")
  end
end
