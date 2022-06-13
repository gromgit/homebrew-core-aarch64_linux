class Xpipe < Formula
  desc "Split input and feed it into the given utility"
  homepage "https://www.netmeister.org/apps/xpipe.html"
  url "https://www.netmeister.org/apps/xpipe-1.0.tar.gz"
  sha256 "6f15286f81720c23f1714d6f4999d388d29f67b6ac6cef427a43563322fb6dc1"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.netmeister.org/apps/"
    regex(/href=.*?xpipe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xpipe"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fc3a26a591b1d97d7f488151ef62fde510d08d3bbe4c4d90d77415e20cda1cbc"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "echo foo | xpipe -b 1 -J % /bin/sh -c 'cat >%'"
    assert_predicate testpath/"1", :exist?
    assert_predicate testpath/"2", :exist?
    assert_predicate testpath/"3", :exist?
  end
end
