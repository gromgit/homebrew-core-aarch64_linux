class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.10.4.tar.gz"
  sha256 "779752e853d5f59d73e37a74681d52ba6f98ecb54c31fe266d4b85bedafc7774"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a699aa537b1b8a0f10cc882fd853c5a6ee90d392c96b7340cadd961be45b87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4ee00f3bfcc9c76d20dbf2cd9796039662e0a533cb5e3f0fa10199252d83bf9"
    sha256 cellar: :any_skip_relocation, monterey:       "5bbea72d9fcc4290cfc6531cdbb1a776ca2b83d83250a32fe6b449422977699f"
    sha256 cellar: :any_skip_relocation, big_sur:        "18d98c2f50f73496a1131a063f956ce1607db7127cbadc7c62c291c69ae5c48b"
    sha256 cellar: :any_skip_relocation, catalina:       "74babe60978f1944c44e25b7a02bedb6813ffe657ff2563381e42aee47aaa3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c1cd7f0cb69f3f4effbf48dded38ee624b9a2b6d5ebdf4ee30e9f35533d3eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
