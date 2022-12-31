class Ccrypt < Formula
  desc "Encrypt and decrypt files and streams"
  homepage "https://ccrypt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ccrypt/1.11/ccrypt-1.11.tar.gz"
  sha256 "b19c47500a96ee5fbd820f704c912f6efcc42b638c0a6aa7a4e3dc0a6b51a44f"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ccrypt"
    sha256 aarch64_linux: "ea4485878075bcf972034e0b90dfaa7393c3a67bc011c31d924a9b6980dae495"
  end

  on_linux do
    on_arm do
      depends_on "libxcrypt"
    end
  end

  conflicts_with "ccat", because: "both install `ccat` binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-lispdir=#{share}/emacs/site-lisp/ccrypt"
    system "make", "install"
    system "make", "check"
  end

  test do
    touch "homebrew.txt"
    system bin/"ccrypt", "-e", testpath/"homebrew.txt", "-K", "secret"
    assert_predicate testpath/"homebrew.txt.cpt", :exist?
    refute_predicate testpath/"homebrew.txt", :exist?

    system bin/"ccrypt", "-d", testpath/"homebrew.txt.cpt", "-K", "secret"
    assert_predicate testpath/"homebrew.txt", :exist?
    refute_predicate testpath/"homebrew.txt.cpt", :exist?
  end
end
