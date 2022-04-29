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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a98e4d70fb5bb2cfa4a57f887fef9aa5ca559e580e19b21f1df77e15fda4c9e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c27be09d9135c7a9966731baf626d2f62adbd6b9666939728051ce083a6c8414"
    sha256 cellar: :any_skip_relocation, monterey:       "1c4f94b8870177c22d8b707125b4f6af70313d4c9b398b2955893cd0ee076e35"
    sha256 cellar: :any_skip_relocation, big_sur:        "526658a44d8ff6244e43d1c7cdadff19e5c5ea5881a76270ad7a2d84a3c474e5"
    sha256 cellar: :any_skip_relocation, catalina:       "5018954a86ffec10121abc197ac7a1a442be2d7ae1d3df4bcb835a592b940fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3416bf3d26e0ac68706cb7bdda52da55d895a187e1f3ff635c68085d646a0481"
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
