class Rcm < Formula
  desc "RC file (dotfile) management"
  homepage "https://thoughtbot.github.io/rcm/rcm.7.html"
  url "https://thoughtbot.github.io/rcm/dist/rcm-1.3.5.tar.gz"
  sha256 "24741e7f26f16a049324baa86af700443c4281e2cde099729d74c4d4b29ebe2d"
  license "BSD-3-Clause"

  # The first-party website doesn't appear to provide links to archive files, so
  # we check the Git repository tags instead.
  livecheck do
    url "https://github.com/thoughtbot/rcm.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rcm"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b42d3b8775517a45188e422020d6134cb1d35d86589644f3bc628eabfd80d34c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/".dotfiles").mkdir
    (testpath/".gitconfig").write <<~EOS
      [user]
      	name = Test User
      	email = test@test.com
    EOS
    assert_match(/(Moving|Linking)\.\.\./x, shell_output("#{bin}/mkrc -v ~/.gitconfig"))
  end
end
