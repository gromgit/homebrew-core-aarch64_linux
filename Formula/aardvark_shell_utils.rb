class AardvarkShellUtils < Formula
  desc "Utilities to aid shell scripts or command-line users"
  homepage "http://www.laffeycomputer.com/shellutils.html"
  url "https://web.archive.org/web/20170106105512/downloads.laffeycomputer.com/current_builds/shellutils/aardvark_shell_utils-1.0.tar.gz"
  sha256 "aa2b83d9eea416aa31dd1ce9b04054be1a504e60e46426225543476c0ebc3f67"
  license "GPL-2.0-or-later"

  # This regex is multiline since there's a line break between `href=` and the
  # attribute value on the homepage.
  livecheck do
    url :homepage
    regex(/href=.*?aardvark_shell_utils[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aardvark_shell_utils"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6839042c086650d5cc78f63e6dd09215f86ba81ab92d84a99e3598cecc55da3f"
  end

  conflicts_with "coreutils", because: "both install `realpath` binaries"
  conflicts_with "uutils-coreutils", because: "both install `realpath` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "movcpm", shell_output("#{bin}/filebase movcpm.com").strip
    assert_equal "com", shell_output("#{bin}/fileext movcpm.com").strip
    assert_equal testpath.realpath.to_s, shell_output("#{bin}/realpath .").strip
  end
end
