class Jrsonnet < Formula
  desc "Rust implementation of Jsonnet language"
  homepage "https://github.com/CertainLach/jrsonnet"
  url "https://github.com/CertainLach/jrsonnet/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "f35d4c2ed7a1efada7768deadb5c7509e71846844d14108d68334db9d10645fb"
  license "MIT"
  head "https://github.com/CertainLach/jrsonnet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "059cd2549df2910dcc08b405fe9a927057d44cad1f63ebf222304cb3489c8ff2"
    sha256 cellar: :any_skip_relocation, big_sur:       "88dca211837dfb36ffbcb6b5b5efb0d7245f82f2885e3c537b7ca96ff856ffe6"
    sha256 cellar: :any_skip_relocation, catalina:      "dddef69f27bd0ed421cc3d2458ee98dc236b0348b9592f8bc199e8db00100cfe"
    sha256 cellar: :any_skip_relocation, mojave:        "2aa7a841332b726e21ea560d3b62f9c35b17e42da6b464fca0099dee0d432fb2"
  end

  depends_on "rust" => :build

  def install
    cd "cmds/jrsonnet" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal "2\n", shell_output("#{bin}/jrsonnet -e '({ x: 1, y: self.x } { x: 2 }).y'")
  end
end
