class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.11.0.tar.gz"
  sha256 "965e51c91ad9851e2337aebcc0f517440c637c506f3a03948062e3d5ea129a83"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libvpx"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ebf2734161dcc33ad47c2ebd85f62ee816d4e66ec814cde7924ae057ab0fb8d7"
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

    # `configure` misdetects Monterey as `generic-gnu`.
    # Reported via email to https://groups.google.com/a/webmproject.org/group/codec-devel
    args << "--target=#{Hardware::CPU.arch}-darwin20-gcc" if OS.mac? && MacOS.version >= :monterey

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
