class Sponge < Formula
  desc "Soak up standard input and write to a file"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.67.tar.gz"
  sha256 "03872f42c22943b21c62f711b693c422a4b8df9d1b8b2872ef9a34bd5d13ad10"
  license "GPL-2.0-only"

  livecheck do
    url "https://git.joeyh.name/index.cgi/moreutils.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sponge"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f3344a5f28b2af8a49860e20f6611938accd5287e93a8006bb93fcb688b514a9"
  end

  conflicts_with "moreutils", because: "both install a `sponge` executable"

  def install
    system "make", "sponge"
    bin.install "sponge"
  end

  test do
    file = testpath/"sponge-test.txt"
    file.write("c\nb\na\n")
    system "sort #{file} | #{bin/"sponge"} #{file}"
    assert_equal "a\nb\nc\n", File.read(file)
  end
end
