class VisionmediaWatch < Formula
  desc "Periodically executes the given command"
  homepage "https://github.com/tj/watch"
  url "https://github.com/tj/watch/archive/0.4.0.tar.gz"
  sha256 "d37ead189a644661d219b566170122b80d44f235c0df6df71b2b250f3b412547"
  license "MIT"
  head "https://github.com/tj/watch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/visionmedia-watch"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3ed0d4aa553006b0a0f2f4137f66830d8e51afe9426ebf81155251cf241598bb"
  end

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
