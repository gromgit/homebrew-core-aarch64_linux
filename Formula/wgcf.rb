class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.14.tar.gz"
  sha256 "64b6e62cc9b7ca1b91757ee067e7c6adf923faff64e3daeebbf07ad817ce73aa"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4aa3c2d595d861037c57d1b5ce225a57cd19a043435ed31c3e310f9a19c6ba4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3101a3b22787589a2383081a076e92b1993078cb498ff729ed645785cd48be92"
    sha256 cellar: :any_skip_relocation, monterey:       "ee4f4310ffa4a121e02e254a20b0e012b29f5e837e7808078241e2f99996a71a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6acec9344f3955b19706a4f43cd3ffce9b6e1ce6085595029b08f75d614ed980"
    sha256 cellar: :any_skip_relocation, catalina:       "86d44c840e65e385aad006e8fa94929d402283899ddbe86ae431662afa5698fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55d5f82e2dc8c5a5b47896e59ad99d29389ddb6ec09ddc056da49e6508b6632f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
