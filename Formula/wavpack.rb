class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.6.0.tar.bz2"
  sha256 "8cbfa15927d29bcf953db35c0cfca7424344ff43ebe4083daf161577fb839cc1"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wavpack"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6124b1e07ed1e7c7080ec271f4382338fc7ebe1f583b8e37444e98dc50af750c"
  end

  head do
    url "https://github.com/dbry/WavPack.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    # ARM assembly not currently supported
    # https://github.com/dbry/WavPack/issues/93
    args << "--disable-asm" if Hardware::CPU.arm?

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    assert_predicate testpath/"test.wv", :exist?
  end
end
