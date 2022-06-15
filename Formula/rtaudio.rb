class Rtaudio < Formula
  desc "API for realtime audio input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtaudio/"
  url "https://www.music.mcgill.ca/~gary/rtaudio/release/rtaudio-5.2.0.tar.gz"
  sha256 "d6089c214e5dbff136ab21f3f5efc284e93475ebd198c54d4b9b6c44419ef4e6"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?rtaudio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rtaudio"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "842a63278f01831ca5d67e6ef3e4b48e109fb96a4113ad4dd5bcfca0f40aa7b2"
  end

  head do
    url "https://github.com/thestk/rtaudio.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.cxx11
    system "./autogen.sh", "--no-configure" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
    doc.install %w[doc/release.txt doc/html doc/images] if build.stable?
    (pkgshare/"tests").install "tests/testall.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"tests/testall.cpp", "-o", "test", "-std=c++11",
           "-I#{include}/rtaudio", "-L#{lib}", "-lrtaudio"
    system "./test"
  end
end
