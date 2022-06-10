class VisionmediaWatch < Formula
  desc "Periodically executes the given command"
  homepage "https://github.com/visionmedia/watch"
  url "https://github.com/visionmedia/watch/archive/0.4.0.tar.gz"
  sha256 "d37ead189a644661d219b566170122b80d44f235c0df6df71b2b250f3b412547"
  license "MIT"
  head "https://github.com/visionmedia/watch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/visionmedia-watch"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "de118afe3977fb0009c637b877aa82ac2610bcb428a8f072a3e372462e53d74b"
  end

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
