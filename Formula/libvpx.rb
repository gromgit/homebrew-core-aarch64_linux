class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.12.0.tar.gz"
  sha256 "f1acc15d0fd0cb431f4bf6eac32d5e932e40ea1186fe78e074254d6d003957bb"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libvpx"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "21505329d6f3d71cd1c45d898f727e36c22cd988d076099fb32fe5a208490498"
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

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end
