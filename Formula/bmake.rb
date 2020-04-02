class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200330.tar.gz"
  sha256 "d7257cbc50b1aa681088c831ab24379e268f3336a8da4af76fc320af24e75099"

  bottle do
    sha256 "61b77e5ea73e1cdaf0188d68b3ca2b06d49651bb210c3800d7227f07765788fb" => :catalina
    sha256 "d478f714529d5893085fdc064863caaa429b3b21b125269b88932f39a3b60997" => :mojave
    sha256 "318d703f8a240bd5fe27eb43714660f3d59b1bffdce8007e36cc5a5d77487cdc" => :high_sierra
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
