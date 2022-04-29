class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.54.tar.gz"
  sha256 "23cc95a16e48e2dac59a23bff110e38d5c50fb309fe7aa997d59828ab1206f21"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7a7e9162ce67cea538aa4ede43a1aa673c30cea30968f7b323259875019911d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d575d6c6f28ab4738284e01a70ba8413da924dafe41e882c50f4b99752f49ed"
    sha256 cellar: :any_skip_relocation, monterey:       "d689cd455aed8af60df7258c86e95ca7e26f21757607075baf09053599e1809e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ded7e647d018d7978f34aaf775ddd8aaf0044e28f1c44e81431a7ca06a0c245f"
    sha256 cellar: :any_skip_relocation, catalina:       "08e3bf02fb009c509a3bfa63c905952ce32d93fdc1cf6c9d02d1931b1344fbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae689bbea36ba4f7403e81b85d7a38ec4ee2cffc4263f379c060ffb6607a5f5"
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
