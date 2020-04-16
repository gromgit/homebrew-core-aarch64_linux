class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  revision 1
  head "https://github.com/labjack/exodriver.git"

  stable do
    url "https://github.com/labjack/exodriver/archive/v2.5.3.tar.gz"
    sha256 "24cae64bbbb29dc0ef13f482f065a14d075d2e975b7765abed91f1f8504ac2a5"

    # Fix "__dyld section not supported".
    # Remove with the next release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/f33e3149628486cd4db494e259001f4ee59f8694/exodriver/2.5.3-dyld.patch"
      sha256 "9098aabb25c65d4e9bafcab9640f3422e28a9000603c4d5c26525a51fe880bbb"
    end
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "d0b269dc59c28dd739a3596d300de53b195efbc0a897fc15993526fe8cf9416a" => :catalina
    sha256 "2fae34af7c35f396fd6cc26143da484be3ca4bf51a900a76650096bbe40adb5c" => :mojave
    sha256 "2be616189c54c4d1046b8d8fbddfb6366a64149f37927ed692413c154cbdae96" => :high_sierra
    sha256 "7d02fce0526573c60aebe7a30e0b3b60d114cc95f4e59f0575b508b65409f187" => :sierra
    sha256 "15753f1e5a45758a67429900cafdc4954fe9bc00c2ed0b2cf45b7a2a4544c24f" => :el_capitan
  end

  depends_on "libusb"

  def install
    system "make", "-C", "liblabjackusb", "install",
           "HEADER_DESTINATION=#{include}", "DESTINATION=#{lib}"
    ENV.prepend "CPPFLAGS", "-I#{include}"
    ENV.prepend "LDFLAGS", "-L#{lib}"
    system "make", "-C", "examples/Modbus"
    pkgshare.install "examples/Modbus/testModbusFunctions"
  end

  test do
    output = shell_output("#{pkgshare}/testModbusFunctions")
    assert_match /Result:\s+writeBuffer:/, output
  end
end
