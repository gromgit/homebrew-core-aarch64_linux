class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "https://www.jedsoft.org/slang/"
  url "https://www.jedsoft.org/releases/slang/slang-2.3.2.tar.bz2"
  mirror "https://src.fedoraproject.org/repo/pkgs/slang/slang-2.3.2.tar.bz2/sha512/35cdfe8af66dac62ee89cca60fa87ddbd02cae63b30d5c0e3786e77b1893c45697ace4ac7e82d9832b8a9ac342560bc35997674846c5022341481013e76f74b5/slang-2.3.2.tar.bz2"
  sha256 "fc9e3b0fc4f67c3c1f6d43c90c16a5c42d117b8e28457c5b46831b8b5d3ae31a"
  license "GPL-2.0"

  livecheck do
    url "https://www.jedsoft.org/releases/slang/"
    regex(/href=.*?slang[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/s-lang"
    sha256 aarch64_linux: "f0ad887cb5c692d1af348892c3505603667f002b3140172af78580088403e70a"
  end

  depends_on "libpng"

  on_linux do
    depends_on "pcre"
  end

  def install
    png = Formula["libpng"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png.lib}",
                          "--with-pnginc=#{png.include}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/slsh -e 'message(\"Hello World!\");'").strip
  end
end
