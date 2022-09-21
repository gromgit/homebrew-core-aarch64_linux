class Heatshrink < Formula
  desc "Data compression library for embedded/real-time systems"
  homepage "https://github.com/atomicobject/heatshrink"
  url "https://github.com/atomicobject/heatshrink/archive/v0.4.1.tar.gz"
  sha256 "7529a1c8ac501191ad470b166773364e66d9926aad632690c72c63a1dea7e9a6"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/heatshrink"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "15b1d1435df441ca3fef9a537c798f765391aa4815889702e1e24a6faf4ca52d"
  end

  def install
    mkdir_p prefix/"bin"
    mkdir_p prefix/"include"
    mkdir_p prefix/"lib"
    system "make", "test_heatshrink_dynamic"
    system "make", "test_heatshrink_static"
    system "make", "install", "PREFIX=#{prefix}"
    (pkgshare/"tests").install "test_heatshrink_dynamic", "test_heatshrink_static"
  end

  test do
    system pkgshare/"tests/test_heatshrink_dynamic"
    system pkgshare/"tests/test_heatshrink_static"
  end
end
