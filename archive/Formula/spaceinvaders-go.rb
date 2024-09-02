class SpaceinvadersGo < Formula
  desc "Space Invaders in your terminal written in Go"
  homepage "https://github.com/asib/spaceinvaders"
  url "https://github.com/asib/spaceinvaders/archive/v1.2.1.tar.gz"
  sha256 "3fef982b94784d34ac2ae68c1d5dec12e260974907bce83528fe3c4132bed377"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/spaceinvaders-go"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1124b7409488871a25446ab2caa09e7507f7789208e758d83a821d7fbdbe1bb6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "-o", bin/"spaceinvaders"
  end

  test do
    IO.popen("#{bin}/spaceinvaders", "r+") do |pipe|
      pipe.puts "q"
      pipe.close_write
      pipe.close
    end
  end
end
