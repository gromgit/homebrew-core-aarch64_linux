class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/cointop-sh/cointop/archive/v1.6.10.tar.gz"
  sha256 "18da0d25288deec7156ddd1d6923960968ab4adcdc917f85726b97d555d9b1b7"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cointop"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "82be65ea7352e6a28154839cc876fca8edcd7b702f37642f17a4244106c89335"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/cointop-sh/cointop/cointop.version=#{version}")
  end

  test do
    system bin/"cointop", "test"
  end
end
