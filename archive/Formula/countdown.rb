class Countdown < Formula
  desc "Terminal countdown timer"
  homepage "https://github.com/antonmedv/countdown"
  url "https://github.com/antonmedv/countdown/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "51fe9d52c125b112922d5d12a0816ee115f8a8c314455b6b051f33e0c7e27fe1"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/countdown"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9b22a455a6da1baf9018bf2aa5e5f3cedde4d9cebee54f0bf054521a5964d5ce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pipe_output bin/"countdown", "0m0s"
  end
end
