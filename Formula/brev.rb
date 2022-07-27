class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.90.tar.gz"
  sha256 "d6299cf97611d56d022e6cf7504480b4fe3cfb8c40c3f7540483e59c879fc0b6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4118cf9f5117bfdbc390eedd9059ab9fa78b9b5d97182ed5b0dcf1f919ca8f41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58a7bdb6d2d4f868b1c55b0da5c32b82bdc314d1ff04bc3ec0412cc657702003"
    sha256 cellar: :any_skip_relocation, monterey:       "46be972f21764071e12e5f6648a9174dfabedb2184e581c0d1942ce0d776ca68"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6c9bfd39989f299d3dbd643c1715b2d0880087b36a51965894d2400165a5ccb"
    sha256 cellar: :any_skip_relocation, catalina:       "f13bbc06afaaead7407909a636e8f72b9fa43b848bc80846a91139fe389d9e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e87242202502640a7eba367e958c4ebfa99f09e6e4f063177d4399ca17ae4b61"
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
