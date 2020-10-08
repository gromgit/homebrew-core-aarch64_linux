class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.18.0.tar.gz"
  sha256 "f7418109e89a8280f2181c675a7790669ba0b0ba5c0eae2bca13879257f96d57"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "85b3fb674ef3946a25e14c89239effff331e6fd9de986932537066d42e62072f" => :catalina
    sha256 "789998f2e911d299619dc48ef5065daa6c376ac79ecae129c7fa34bd1b5b95e8" => :mojave
    sha256 "48fb69d4fc789942392ee92d5c284c819cd02d50d101739f30a8f2a2506f16af" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  test do
    system "#{bin}/#{name}"
  end
end
