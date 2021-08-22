class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/v1.6.6.tar.gz"
  sha256 "f8f10ced1e46a6c7ce72875f2834f4c6116b947fa794cd078c4c4eac4c62d1f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce99c2a52eb9f4484b6dfa2818364f07ebb9c92f5a930105a08126dbd94a5859"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9350b2dc213f157733a01ce156b5a19eb5a9362d5cd60490bef70e2d8ff515f"
    sha256 cellar: :any_skip_relocation, catalina:      "66c61859e21c0a1f023876ffef77d54b9a4478de175451f8f02de19263fa9afb"
    sha256 cellar: :any_skip_relocation, mojave:        "5c5deab64598bbafcfe753de6cc9189c3bd89e1db75ff0097e70281c28496812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d2a9f70e1bb4d922d1a9b3b484ed5410aa2ef794f70f7dd8165e07bcba95d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X github.com/miguelmota/cointop/cointop.version=#{version}"
  end

  test do
    system bin/"cointop", "test"
  end
end
