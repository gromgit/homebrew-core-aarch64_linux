class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.101.tar.gz"
  sha256 "1f76d7126070985fca61127ae66a5f5ec681cf6c51b150e6c4fa1b876a82351c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c5cc884fa9bca8c7f3436652e5eea80c68f686811e20ea743eca949872ba433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c483c1f0600f2bf1aeac19bf5d468fe412bb9701c8f0246e7cdd1de0e66b9c82"
    sha256 cellar: :any_skip_relocation, monterey:       "5956266e9ce5186f6ea70bf2f70e094dd17f34ee43edb674d117d6ef5bf6d136"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3e773bd37ec39349532767d973ead000d585c9b7116f7da6b99c0c60cc8e101"
    sha256 cellar: :any_skip_relocation, catalina:       "8417c21d66703e773868bbb4b438eb847b5bde3cbd643d90bf054c4a1d218a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61590c4d349be498c8634285313ea920597d9cee7b81cc588a9eb24963a2b166"
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
