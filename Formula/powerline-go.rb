class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.16.1.tar.gz"
  sha256 "3c9ba9265ae3c53eeb08cd0ee4324961f0a6b1f99cd0059318180796959bf5df"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3904584cc8da7767d1edd7c97abde35b4368e47f187e78d36fc208cbfcc7a11" => :catalina
    sha256 "81a045e185ed9654ae30a8d025e7259f68d56e9741f81fdee5b61a5708e8ba0f" => :mojave
    sha256 "89111b7e2c874ad417a19891fd1e101c7254bb0913c8a0c5bf2e03277fbbbfb8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  test do
    system "#{bin}/#{name}"
  end
end
