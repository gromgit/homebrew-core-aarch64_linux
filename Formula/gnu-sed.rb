class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.9.tar.xz"
  sha256 "6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gnu-sed"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "612532367610b4e87c5751e4348c0003a18535c1a00eaaa86c06e6bea6577c2a"
  end

  conflicts_with "ssed", because: "both install share/info/sed.info"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << if OS.mac?
      "--program-prefix=g"
    else
      "--without-selinux"
    end
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gsed" =>"sed"
      (libexec/"gnuman/man1").install_symlink man1/"gsed.1" => "sed.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "sed" has been installed as "gsed".
        If you need to use it as "sed", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"test.txt").write "Hello world!"
    if OS.mac?
      system "#{bin}/gsed", "-i", "s/world/World/g", "test.txt"
      assert_match "Hello World!", File.read("test.txt")

      system "#{opt_libexec}/gnubin/sed", "-i", "s/world/World/g", "test.txt"
    else
      system "#{bin}/sed", "-i", "s/world/World/g", "test.txt"
    end
    assert_match "Hello World!", File.read("test.txt")
  end
end
