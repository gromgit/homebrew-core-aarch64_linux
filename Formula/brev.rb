class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.57.tar.gz"
  sha256 "fbd790054a0cbc5b7d3aa9ac2234906a673c2cb415e983db6872a248a9871b99"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cea77226baf2abca2e636246ff96db34a2e479aed65281d5c1f664772392d38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa123bb893f37a6e6de1a0544fb9b866e312a4e8c8eba7731c95ed8100429da3"
    sha256 cellar: :any_skip_relocation, monterey:       "ce7be9930f582e1e9f6d45f578a7fcccbe202da966db277e86fede1d4ed0c689"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3473506a37b9a7ba5366f3f5f938c4dd808035e30285a09bef1981eb999c734"
    sha256 cellar: :any_skip_relocation, catalina:       "3999f961451c70b4fbb7fc9562a2cfbcd1febfde7a4d0503595041df573a0ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270c171409348961dc260eb850a8d546ea2d080bd0a98fbfd43fe2ebf60f31ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
