class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.8.1.tar.gz"
  sha256 "53b284a4829c2eba2defa8d03d12dbe81e3808cf91a31bbef591fd8e16f8c610"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d37a5e5bcca09467bc7d7cefbb0336ca498d535c2cd36f0ec5a98883b79e133"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17c7ddf1212bf27d47e36b641dd970286d10cdbaa6a2bab09738020b18b1c467"
    sha256 cellar: :any_skip_relocation, monterey:       "11111a5b6e47da8150d9ce1cc704bff4a46456b9a8402767474778db6f0c1abc"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc4dcd7ca5f42cbc28b27f3467a456a371716c5e18e9b55d67950252edb96a39"
    sha256 cellar: :any_skip_relocation, catalina:       "bbec34fa65b70162bddcf72affe5e91958f1d21600d3ac70bf0b9a7ef4a766f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "206b6170ee8f718709257a17b00a2cbcab4e718d0adbd3069dda2d2d1230a60c"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
