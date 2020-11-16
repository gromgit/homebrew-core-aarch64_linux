class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.11.tar.gz"
  sha256 "551f1573a98082973e8e2f0ef14be8f34299c9813d58387f9edd32142e6f913b"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "85bfabeddc282a11cc9357342fa004417aedee644efe2ac9bcfd8068f841bf1d" => :big_sur
    sha256 "760e3a2b0d9978f936d760424f091aa5dfe400eba58d8deb26c8171d7a672837" => :catalina
    sha256 "5f471633c508cbd62168bbb6802cc32d44e94259f7ed47adf5ca100f063b8ebe" => :mojave
    sha256 "2920a196fa5880e7021475bf279dca9ca5b5c7795d73e2e28a134e5c81b4273a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      FAudio is built without FFmpeg support for decoding xWMA resources.
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lfaudio", "-o", "test"
    system "./test"
  end
end
