class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.58.tar.gz"
  sha256 "7b97ae6ab88ffdd2953ac7eb8c425e951d9aa84e7f3d71c2faeff8399ec10e58"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef87daea1316b426c4df50e84cc11e07571b15884b2c827fc8752f23d8017786"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ba6c07a1c314632cae25495fe4fdfa5578728a002ededd6e69c3baa2f4d05f5"
    sha256 cellar: :any_skip_relocation, monterey:       "9aedf9447ff2086a7eeedcd9f253d7f7436863d58f211212fb3d82bfbf45db0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d34e3b095cd8eedd318562da97b5a918331b7e2a4869124dadfa658acfb0c37"
    sha256 cellar: :any_skip_relocation, catalina:       "01575281f238a1f27b52ebefc6f57d56cd6fc6236e84f2dafddca1f810b2a08e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00a5093a4ddb7518ca39c99ffb54f4c2270a4a60a5fa0f27656ce7e5bd8c86bb"
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
