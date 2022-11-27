class GithubKeygen < Formula
  desc "Bootstrap GitHub SSH configuration"
  homepage "https://github.com/dolmen/github-keygen"
  url "https://github.com/dolmen/github-keygen/archive/v1.306.tar.gz"
  sha256 "69fc7ef1bf5c4e958f2ad634a8cc21ec4905b16851e46455c47f9ef7a7220f5d"
  license "GPL-3.0"
  head "https://github.com/dolmen/github-keygen.git", branch: "release"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/github-keygen"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8f0a239ea1439c0cfc2e01858831beb85549633c649a9bd5c3e6b0d679c3abd5"
  end

  def install
    bin.install "github-keygen"
  end

  test do
    system "#{bin}/github-keygen"
  end
end
