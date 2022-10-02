class Ioping < Formula
  desc "Tool to monitor I/O latency in real time"
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/archive/v1.3.tar.gz"
  sha256 "7aa48e70aaa766bc112dea57ebbe56700626871052380709df3a26f46766e8c8"
  license "GPL-3.0-or-later"
  head "https://github.com/koct9i/ioping.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ioping"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "83259c2248dba894dba8d62971081a2e13c3ba8f9bb8d093642e0cca24c7712f"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-c", "1", testpath
  end
end
