class Libnet < Formula
  desc "C library for creating IP packets"
  homepage "https://github.com/sam-github/libnet"
  url "https://github.com/libnet/libnet/releases/download/v1.2/libnet-1.2.tar.gz"
  sha256 "caa4868157d9e5f32e9c7eac9461efeff30cb28357f7f6bf07e73933fb4edaa7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "426becf4736494f39a32fae71916ad8ed2784c9a1f14d2a6b963d8f1c7ae2f9f" => :catalina
    sha256 "acafac211b84c80292796e6ee62f0ab92ef047a771b0e76ad31b359cbaa7b936" => :mojave
    sha256 "2adca799087317fa0c93f750239e8be5a746fc0369bd6e7bbb6bc2d79ebe5f5d" => :high_sierra
    sha256 "2b31af371d3516aae63436e1c12b40f474fd69b1126e6d75bed9d4853fbd4ffc" => :sierra
    sha256 "26a496e3607f2639592617769522a790259c834f91c05d91721331fe6f1ad0c4" => :el_capitan
    sha256 "4203e91b8334689591d1dcec4e2f11625b035dbef078dd7f63121dbf3959e69b" => :yosemite
    sha256 "fd35c44586c926e10d9cb616e2b33594cb553329735ff2fe9130adfa8ccf17da" => :mavericks
  end

  depends_on "doxygen" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
