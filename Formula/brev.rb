class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.87.tar.gz"
  sha256 "f3f5c5902d62810885be7fc0501961df5120cd0ea21bd477806e13775e1e213b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5b178a0888a78bdcae59739c713fde443d0da5f3e03cd6c8e8bac0bee81e8f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef0809b16d81138cc9bfb245c43cac6376c11fc62f2a1c61d3f578a36166128b"
    sha256 cellar: :any_skip_relocation, monterey:       "cff4c0741e668d67f2aba3027ae40cd0c87c8abe1692adfa8bbcbab996337700"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdf219f7e068c55d604597ef496117cd65cebfb25680b70c860106762c23b753"
    sha256 cellar: :any_skip_relocation, catalina:       "f89034921d11fc9a7b58a645eb3acd8854f044f7ecabbca925e195d7c0d47382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74ef3e1b4f304871650f51a0f252f10f95db86cb81ed93cc698872a041d4062d"
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
