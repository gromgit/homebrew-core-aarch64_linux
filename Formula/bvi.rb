class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "https://bvi.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bvi/bvi/1.4.1/bvi-1.4.1.src.tar.gz"
  sha256 "3035255ca79e0464567d255baa5544f7794e2b7eb791dcc60cc339cf1aa01e28"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bvi"
    sha256 aarch64_linux: "aaabbd2a80a3b7a9276e35626f6adadafedebd559735c6c09b8d0fdd5702198e"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bvi", "-c", "q"
  end
end
