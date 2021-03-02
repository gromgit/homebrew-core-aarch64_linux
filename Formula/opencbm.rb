class Opencbm < Formula
  desc "Provides access to various floppy drive formats"
  homepage "https://spiro.trikaliotis.net/opencbm"
  url "https://github.com/OpenCBM/OpenCBM/archive/v0.4.99.103.tar.gz"
  sha256 "026b0aa874b85763027641cfd206af92172d1120b9c667f35050bcfe53ba0b73"
  license "GPL-2.0-only"
  head "https://git.code.sf.net/p/opencbm/code.git"

  livecheck do
    url :homepage
    regex(/<h1[^>]*?>VERSION v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 arm64_big_sur: "badee8af25b105994dbae61bc458d97cece5d627cc801d131d5f9575dcd2a7d7"
    sha256 big_sur:       "2c6f695b90e4b6dec2954d4cab254abe8563998311634ced199641a9b8c65aca"
    sha256 catalina:      "0fcf92ca18ebde6b9d431dfd1ab8667ca93ee59c53f85e818eed9f0b8ba78306"
    sha256 mojave:        "489ae793f9f226c93667cf67f23d7eac1cde97d4ed33549bbe9731fcc824eb2a"
    sha256 high_sierra:   "d9555da83fc70f801663f13cfc4ed34241feec72d29125fb12a2105fce414210"
    sha256 sierra:        "6ff076233d442f7f15e22595623cf46c38cf1024997240bd48db1e4bb01c44c2"
    sha256 el_capitan:    "6ba3fc869e59f002f6ae897cbb34b4ece023c11371c3d611453b330714b65cba"
  end

  # cc65 is only used to build binary blobs included with the programs; it's
  # not necessary in its own right.
  depends_on "cc65" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    # This one definitely breaks with parallel build.
    ENV.deparallelize

    args = %W[
      -fLINUX/Makefile
      LIBUSB_CONFIG=#{Formula["libusb-compat"].bin}/libusb-config
      PREFIX=#{prefix}
      MANDIR=#{man1}
    ]

    system "make", *args
    system "make", "install-all", *args
  end

  test do
    system "#{bin}/cbmctrl", "--help"
  end
end
