class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.14.tar.gz"
  sha256 "64b6e62cc9b7ca1b91757ee067e7c6adf923faff64e3daeebbf07ad817ce73aa"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wgcf"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "93fb969af13c9f8f423b88cb0e7c892370b84e24aa613ad154593eef5f80e209"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
