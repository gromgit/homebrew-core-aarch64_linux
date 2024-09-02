class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.3.2.tar.gz"
  sha256 "ef8ce23df38d5076d25510baa2cabedffbe0af460d887d86c2413a1c2b0c676f"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/librsync"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8c618502aa0a0fb327d157b3a9cc93d7d618b1b92d3f6e4143a6cfd382a4f6c8"
  end


  depends_on "cmake" => :build
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
