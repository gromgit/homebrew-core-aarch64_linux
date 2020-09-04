class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.1.3.tar.gz"
  sha256 "cfc042ff45d627e0d80e2ea3d0e80551dc72955ada126ad0c1385e2620939d82"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4aa29d04c3f0bd7f3f3f77de7082bdb785ed3f6036a7239121e9eb0224130d23" => :catalina
    sha256 "3ac9951d126b6d2d392bd3a8dc2e25d471be15b821b1363e49cdbe4fed0b204b" => :mojave
    sha256 "ddddf71f9c27005933a372c92ad51902dcc2b13f06aba39d44b5bab392c277fe" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
