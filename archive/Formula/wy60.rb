class Wy60 < Formula
  desc "Wyse 60 compatible terminal emulator"
  homepage "https://code.google.com/archive/p/wy60/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/wy60/wy60-2.0.9.tar.gz"
  sha256 "f7379404f0baf38faba48af7b05f9e0df65266ab75071b2ca56195b63fc05ed0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wy60"
    sha256 aarch64_linux: "b24ef39cb73a516460b9856cf2d445bed5ed9d4b5d641692d76c64468f31f809"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wy60", "--version"
  end
end
