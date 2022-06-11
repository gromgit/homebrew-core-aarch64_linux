class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.37.tar.xz"
  sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/binutils"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "296337e8c7071398f74f5e13385558ce81e4249544e0cda720d3e38a4df6f54f"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-gold",
                          "--enable-plugins",
                          "--enable-targets=all",
                          "--with-system-zlib",
                          "--disable-nls"
    system "make"
    system "make", "install"
    bin.install_symlink "ld.gold" => "gold"
    if OS.mac?
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    else
      # Reduce the size of the bottle.
      system "strip", *Dir[bin/"*", lib/"*.a"]
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
