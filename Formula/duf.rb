class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.6.1.tar.gz"
  sha256 "a80ca8ba79b7f7b9a8433652e595220039627de575fe920e78d2aeab40b6cc9c"
  license "MIT"
  head "https://github.com/muesli/duf.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3556473b7f52a6e0827c7081010f17400929542c35470b0d8c8960fe5f5f0528"
    sha256 cellar: :any_skip_relocation, big_sur:       "ecb3b0d979a756c9e3551b7052a1d16a9d46fdf8310fa0472fde2400452abba8"
    sha256 cellar: :any_skip_relocation, catalina:      "afc2b4a8a42ab1d1f59f3cac6b77522e5c2ac66366a1121aa32b75f6ddfd99be"
    sha256 cellar: :any_skip_relocation, mojave:        "1412849b86eddeff3f933ce283eceaf07f9916a41a6b772cfc34b3fcf0bb339e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "json"

    devices = JSON.parse shell_output("#{bin}/duf --json")
    assert root = devices.find { |d| d["mount_point"] == "/" }
    assert_equal "local", root["device_type"]
  end
end
