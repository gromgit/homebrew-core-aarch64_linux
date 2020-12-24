class GitRemoteGcrypt < Formula
  desc "GPG-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://github.com/spwhitton/git-remote-gcrypt/archive/1.3.tar.gz"
  sha256 "e1948dda848db845db404e4337b07206c96cb239b66392fd1c9c246279c2cb25"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "feb525041cfdf3a36d3d8e7a0c701ec73d1d0bcf90ebb8e900cee2113cd1c8d7" => :big_sur
    sha256 "6eed2947d709e4f6e233b9d4aad27aa46ebb30c9da03b0021076b98fdbf88115" => :arm64_big_sur
    sha256 "40fe96f458da47660ec153c19efc0271f9f8bcd987cf328081873adecffd6a88" => :catalina
    sha256 "c475f8f9a231038a1dcebdf37d14255ed9abb8e242cb0fe5a5216c3727ced1f1" => :mojave
    sha256 "40fe96f458da47660ec153c19efc0271f9f8bcd987cf328081873adecffd6a88" => :high_sierra
  end

  depends_on "docutils" => :build

  def install
    ENV["prefix"] = prefix
    system "./install.sh"
  end

  test do
    assert_match("fetch\npush\n", pipe_output("#{bin}/git-remote-gcrypt", "capabilities\n", 0))
  end
end
