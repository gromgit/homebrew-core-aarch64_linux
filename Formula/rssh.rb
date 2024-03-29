class Rssh < Formula
  desc "Restricted shell for use with OpenSSH"
  homepage "http://www.pizzashack.org/rssh"
  url "https://downloads.sourceforge.net/project/rssh/rssh/2.3.4/rssh-2.3.4.tar.gz"
  sha256 "f30c6a760918a0ed39cf9e49a49a76cb309d7ef1c25a66e77a41e2b1d0b40cd9"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rssh"
    sha256 aarch64_linux: "21ea87e39ca9521eef8a9531e15a3febdaf6724ec1f9b7873609472b3c8e2803"
  end

  deprecate! date: "2021-01-22", because: :unmaintained

  # Submitted upstream:
  # https://sourceforge.net/p/rssh/mailman/message/32251335/
  patch do
    url "https://gist.githubusercontent.com/arminsch/9230011/raw/f0c5ed95bbba0be28ce2b5f0d1080de84ec317ab/rsshconf-log-rename.diff"
    sha256 "abd625a8dc24f3089b177fd0318ffc1cf4fcb08d0c149191bb45943ad55f6934"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    # test to check if everything is linked correctly
    system "#{bin}/rssh", "-v"
    # the following test checks if rssh, if invoked without commands and options, fails
    system "sh", "-c", "! #{bin}/rssh"
  end
end
