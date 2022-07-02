class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.84.tar.gz"
  sha256 "d2a7757bb22e49cb957f57dab39bd10bff0d537657fd63691911f7978d0463a1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c555dd8d1c053cdd5da7750fae2f0f9e9ddb7c01203b6476aca5896a0065fdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb0335a71b8888566109c9bf52b8fb4b8712d3189a93cfde7e4110242bbbde0b"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4dc150d0beb331ba2e2761022b893f3389b5e8d06856ee58ef9fe33a4ddfb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "87cfc71a94ab5ab833aac68b4bf2ebe84759d35c5fba173a5174a52870c10675"
    sha256 cellar: :any_skip_relocation, catalina:       "069f4dcf7076f0bdda3695c5a9514b41a6ed6abc4015f74a1d5662a70373b230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1a15a562c67d92eeac7cddf76d218d789c8cabbc407dec5792bb5d2d815641"
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
