class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "https://www.manyfish.co.uk/pakchois/"
  url "https://www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha256 "d73dc5f235fe98e4d1e8c904f40df1cf8af93204769b97dbb7ef7a4b5b958b9a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?pakchois[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "071f8af3739d95b9aa192ef05d6832c13dc2c857d3d12cf36ef542dc49e20368" => :big_sur
    sha256 "c00b0a1f15ecabd511cae29db368f03b6f29df9ab719a3462b0e7a6044d7208e" => :arm64_big_sur
    sha256 "cb96f79b314a139b4edbce5dbcb4e5c9b4057cf8eb0b86ed848f4acfd2b777d8" => :catalina
    sha256 "794a3b40666739128f8f0ceb0af71dc787c725dc9bfc10a048b79009dfabf4c3" => :mojave
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
