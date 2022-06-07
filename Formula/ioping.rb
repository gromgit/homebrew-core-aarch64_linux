class Ioping < Formula
  desc "Tool to monitor I/O latency in real time"
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/archive/v1.2.tar.gz"
  sha256 "d3e4497c653a1e96df67c72ce2b70da18e9f5e3b93179a5bb57a6e30ceacfa75"
  license "GPL-3.0-or-later"
  head "https://github.com/koct9i/ioping.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ioping"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d82baa6dddf244240fbe0b49f0cc3e59dc8667fb6d9bee1642f9f0e9c2b1568d"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-c", "1", testpath
  end
end
