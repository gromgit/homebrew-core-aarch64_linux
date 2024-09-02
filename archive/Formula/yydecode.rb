class Yydecode < Formula
  desc "Decode yEnc archives"
  homepage "https://yydecode.sourceforge.io"
  url "https://downloads.sourceforge.net/project/yydecode/yydecode/0.2.10/yydecode-0.2.10.tar.gz"
  sha256 "bd4879643f6539770fd23d1a51dc6a91ba3de2823cf14d047a40c630b3c7ba66"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/yydecode"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "52458c68470d3809605e503931899b6e266487a4685e804f59a5c32ecd2a5e44"
  end

  def install
    # Redefinition of type found in 10.13 system headers
    # https://sourceforge.net/p/yydecode/bugs/5/
    inreplace "src/crc32.h", "typedef unsigned long int u_int32_t;", "" if DevelopmentTools.clang_build_version >= 900

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
