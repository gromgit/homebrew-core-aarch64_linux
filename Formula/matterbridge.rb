class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.23.1.tar.gz"
  sha256 "6e5e632298534ae5d557e8c6308457d774447169c356ba157fe4532b9a569e9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7efe7b9e3c85e634a93b0e07a60c32483570919911fd416397c3af8730a558c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a93d34e2c78869e3d3d560e2ae52864d4d9d01ef2624f2a67e16416f06a8b56"
    sha256 cellar: :any_skip_relocation, catalina:      "0578b896635d27b1131a127c42038a2c72e4b1e03499aff78749c38c89b5a867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7b403cae984bee4b96f9629b6ee52b751a0f72f86dac80a270927af7635a60"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
