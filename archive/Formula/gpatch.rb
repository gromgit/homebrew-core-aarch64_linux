class Gpatch < Formula
  desc "Apply a diff file to an original"
  homepage "https://savannah.gnu.org/projects/patch/"
  url "https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/patch/patch-2.7.6.tar.xz"
  sha256 "ac610bda97abe0d9f6b7c963255a11dcb196c25e337c61f94e4778d632f1d8fd"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gpatch"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "47eadb1139eeae6231ab18dff64bbdbb95bee4a747f729bacf956a38066799c8"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testfile = testpath/"test"
    testfile.write "homebrew\n"
    patch = <<~EOS
      1c1
      < homebrew
      ---
      > hello
    EOS
    pipe_output("#{bin}/patch #{testfile}", patch)
    assert_equal "hello", testfile.read.chomp
  end
end
