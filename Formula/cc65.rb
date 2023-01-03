class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "https://github.com/cc65/cc65/archive/V2.19.tar.gz"
  sha256 "157b8051aed7f534e5093471e734e7a95e509c577324099c3c81324ed9d0de77"
  license "Zlib"
  head "https://github.com/cc65/cc65.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cc65"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7e3030df5e6920b7e871936decf21a7c733b50a5323aea0f5657ab40ca1dc56f"
  end

  conflicts_with "grc", because: "both install `grc` binaries"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      Library files have been installed to:
        #{pkgshare}
    EOS
  end

  test do
    (testpath/"foo.c").write "int main (void) { return 0; }"

    system bin/"cl65", "foo.c" # compile and link
    assert_predicate testpath/"foo", :exist? # binary
  end
end
