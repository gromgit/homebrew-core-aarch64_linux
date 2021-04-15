class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "55d517bc4569272a2c9a367a4106c234aba2ffbc"
    version "r3049"
  end

  # There's no guarantee that the versions we find on the `release-macos` index
  # page are stable but there didn't appear to be a different way of getting
  # the version information at the time of writing.
  livecheck do
    url "https://artifacts.videolan.org/x264/release-macos/"
    regex(%r{href=.*?x264[._-](r\d+)[._-][\da-z]+/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "277e4c3771be77c6cc8629194b1af90144e118a70f30f9b388ed8fcc3b0bad3e"
    sha256 cellar: :any, big_sur:       "6d74cd3f80239d92ce03b3ebccd7fdd3033552ed5ac637214d2c7e13e2aac7cd"
    sha256 cellar: :any, catalina:      "e27bf38f83a8b23d3c73d85f3ccb0b5397dbb540a39b40634200c3077b0895f0"
    sha256 cellar: :any, mojave:        "ecb12ab474f372bb0c0c137d4623f31f6daa70011489631f507b914ed38296d3"
  end

  depends_on "nasm" => :build

  if MacOS.version <= :high_sierra
    # Stack realignment requires newer Clang
    # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
    depends_on "gcc"
    fails_with :clang
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s.delete("r"), shell_output("#{bin}/x264 --version").lines.first
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-lx264", "-o", "test"
    system "./test"
  end
end
