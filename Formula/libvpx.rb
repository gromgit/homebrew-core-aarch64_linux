class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.10.0.tar.gz"
  sha256 "85803ccbdbdd7a3b03d930187cb055f1353596969c1f92ebec2db839fa4f834a"
  license "BSD-3-Clause"
  revision 1
  head "https://chromium.googlesource.com/webm/libvpx.git"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "23d8b0c0b6acfba7df69ac222251797efd5db0d5a143494f90ad52d5ff6f4083"
    sha256 cellar: :any,                 big_sur:       "a5c097e3c902b9c1bdfaf6c1100e01366d6537b1983f0bc4075e3a642c8ffab9"
    sha256 cellar: :any,                 catalina:      "ee2c55fcd7d7143a74171c42d227e63c383f46bfe78d2d8fac4dc45cc6a1e8e0"
    sha256 cellar: :any,                 mojave:        "3d578a1b4e7a4cdb73c07b3529b9f90c4cfa6583386035400be5cf85448e625d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8597613378a9e3e33d79dc63db9029edf7376780152eaf55e9ed35581670f2e6"
  end

  depends_on "yasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-shared
      --enable-vp9-highbitdepth
    ]

    if Hardware::CPU.intel?
      ENV.runtime_cpu_detection
      args << "--enable-runtime-cpu-detect"
    end

    # https://bugs.chromium.org/p/webm/issues/detail?id=1475
    args << "--disable-avx512" if MacOS.version <= :el_capitan

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end
