class Pbzip2 < Formula
  desc "Parallel bzip2"
  homepage "https://web.archive.org/web/20180226093549/compression.ca/pbzip2/"
  url "https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz"
  sha256 "8fd13eaaa266f7ee91f85c1ea97c86d9c9cc985969db9059cdebcb1e1b7bdbe6"
  license "bzip2-1.0.6"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pbzip2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "239db6795d6b632c328e9f5a01030b0e6582b54b229618ad06155f0f0f52b0ee"
  end

  uses_from_macos "bzip2"

  def install
    system "make", "PREFIX=#{prefix}",
                   "CC=#{ENV.cxx}",
                   "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end

  test do
    system "#{bin}/pbzip2", "--version"
  end
end
