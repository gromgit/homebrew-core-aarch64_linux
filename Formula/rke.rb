class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.3.10.tar.gz"
  sha256 "482cc06cb621510e3adc19fbe3c07c417a7babb27cc19a3d5c4006c07d7d8be0"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times). We normally avoid checking the releases
  # page because pagination can cause problems but this is our only choice.
  livecheck do
    url "https://github.com/rancher/rke/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ce2407ea06571f5d4c83b0c877455ee8600dd713f3db1093d727e9f3eb171d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a87c96258e9a20bb1649f4d66e57cd32abaf715646df92dd41e0cff7c0a1e03"
    sha256 cellar: :any_skip_relocation, monterey:       "bde562d3b39af0dfc6561c25e79e31f35525ca522690b04ad5550c83ee89ac5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e32208e6aebfcdc819063eabb57cf91121c6ac57dfac9a23764f88258a06a9e"
    sha256 cellar: :any_skip_relocation, catalina:       "0d5ef049a7b2240732c197018430b96ea091adb8d1c38c833d0acc12c5aab228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e599138e074c47b838f8ed0556f1afd10da08bc6dd63c9474e95a437a779b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
