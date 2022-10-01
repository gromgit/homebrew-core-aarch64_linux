class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.116.tar.gz"
  sha256 "2633e6fb33f34d53f4021749bdc6a46a88eca3c91883c763d03b1d25c4396dc0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b5cac2fe3c7abb5ff305d6fe90a39bad7d06c8826d2e6f7a4a56e5d8ef2588"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b0410dd3c1ae25c43bd3dd6b201d9af0cdaa19b68b3148cda7f9dd1410ff38f"
    sha256 cellar: :any_skip_relocation, monterey:       "fa4324cf3076b120fca8403cec91d3119f98beb58062f7d3d24edd7bac864664"
    sha256 cellar: :any_skip_relocation, big_sur:        "755bb4b0bb5c2d2d3b5cc4f01b8346a0dcfb292b5c00a286fd3722aabf648dc6"
    sha256 cellar: :any_skip_relocation, catalina:       "3f490f4848be182c0f45ef699eee10213bca58cb0f9dff94c3b0037e1d7b0ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc20c83277fd2c4fb7eebf9293b8d43d14e77ad166679195a9fc1bf38c5efdc"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
