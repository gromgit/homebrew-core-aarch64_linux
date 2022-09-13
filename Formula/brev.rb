class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.104.tar.gz"
  sha256 "34decf70f69fd3ca6c140d734a7ddf8a29ce3859019a0dcd6209c31099ee37f2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1bf5f59fcaa936a2b5c478680a852a37fe009e72390e4a5f06ff24419b4e3dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fec539c831b9c95f7de568c0c549e379e0e3a10d4434fb375513c23321f5f75"
    sha256 cellar: :any_skip_relocation, monterey:       "40ef701d3c96e765715a2551977b587b7025a1a49ce39a8c6d16c436de99129c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a70eb81def21445c974bf82e9b0eb0007804fdaa13510ad645c602fb0f94128"
    sha256 cellar: :any_skip_relocation, catalina:       "cc6122146938104976841e490b3b009f767050d6c109f64366bf689f7c163fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9315f47182d01c25e6a9fa8d81da6f927b7f3c27480b1f5afea2390b8ec24fed"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
