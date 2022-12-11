class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.187/elfutils-0.187.tar.bz2"
  sha256 "e70b0dfbe610f90c4d1fe0d71af142a4e25c3c4ef9ebab8d2d72b65159d454c8"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-only"]

  livecheck do
    url "https://sourceware.org/elfutils/ftp/"
    regex(%r{href=(?:["']?v?(\d+(?:\.\d+)+)/?["' >]|.*?elfutils[._-]v?(\d+(?:\.\d+)+)\.t)}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/elfutils"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "90002cb9f57d7bd61085f3a61c8ba67fcacfc1ece4a81a586b7a4bcd349ab52c"
  end

  depends_on "m4" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--disable-libdebuginfod",
           "--disable-debuginfod",
           "--program-prefix=elfutils-",
           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "elf_kind", shell_output("#{bin}/elfutils-nm #{bin}/elfutils-nm")
  end
end
