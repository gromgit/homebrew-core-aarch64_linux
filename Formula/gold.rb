class Gold < Formula
  desc "GNU gold linker"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  depends_on :linux

  uses_from_macos "zlib"

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-deterministic-archives",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}",
      "--disable-werror",
      "--enable-gold",
      "--enable-interwork",
      "--enable-multilib",
      "--enable-plugins",
      "--enable-targets=all",
      "--with-system-zlib",
      "--disable-nls",
    ]

    system "./configure", *args
    # Pass MAKEINFO=true to disable generation of HTML documentation.
    # This avoids a build time dependency on texinfo.
    system "make", "all-gold", "MAKEINFO=true"
    system "make", "install-gold", "MAKEINFO=true"
    bin.install_symlink "ld.gold" => "gold"
    system "strip", *bin.children, *lib.glob("*.a")
  end

  test do
    assert_match "fatal error: no input files", shell_output("#{bin}/gold 2>&1", 1)
  end
end
