class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4/"
  url "https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz"
  mirror "https://ftpmirror.gnu.org/m4/m4-1.4.19.tar.xz"
  sha256 "63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/m4-1.4.19"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4510b0a1b1eae8134e8e56f3dd317b8a3bdb3ac43f54e1ffb6da906ce5a42b48"
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Homebrew",
      pipe_output(bin/"m4", "define(TEST, Homebrew)\nTEST\n")
  end
end
