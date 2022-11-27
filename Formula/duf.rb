class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.8.1.tar.gz"
  sha256 "ebc3880540b25186ace220c09af859f867251f4ecaef435525a141d98d71a27a"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/duf"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "807c30b16c0880cd8b1a1cec5ed1172658d6ce23dd6f35735fd692b51f1f659d"
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
