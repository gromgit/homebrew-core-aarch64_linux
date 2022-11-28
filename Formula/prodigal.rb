class Prodigal < Formula
  desc "Microbial gene prediction"
  homepage "https://github.com/hyattpd/Prodigal"
  url "https://github.com/hyattpd/Prodigal/archive/v2.6.3.tar.gz"
  sha256 "89094ad4bff5a8a8732d899f31cec350f5a4c27bcbdd12663f87c9d1f0ec599f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/prodigal"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8b07f2dc85ce3b086e1a69c2a38ec4648a418df71eb8f4213ba48f26f51e0cb6"
  end

  # Prodigal will have incorrect output if compiled with certain compilers.
  # This will be fixed in the next release. Also see:
  # https://github.com/hyattpd/Prodigal/issues/34
  # https://github.com/hyattpd/Prodigal/issues/41
  # https://github.com/hyattpd/Prodigal/pull/35
  on_linux do
    patch do
      url "https://github.com/hyattpd/Prodigal/commit/cbbb5db21d120f100724b69d5212cf1275ab3759.patch?full_index=1"
      sha256 "fd292c0a98412a7f2ed06d86e0e3f96a9ad698f6772990321ad56985323b99a6"
    end
  end

  def install
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    fasta = <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_match "CDS", pipe_output("#{bin}/prodigal -q -p meta", fasta, 0)
  end
end
