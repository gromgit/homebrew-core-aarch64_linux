class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.01.tar.gz"
  sha256 "c015f7d395cf24b9050135238de38683e5a90378215bc6d5bb89777a9623f0e6"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "601470f35aad2e7e0ee58a918a9f47cd50efb3d748aae6e329738f6b7794ca6f" => :catalina
    sha256 "37abc27262cf2b46b4b83ae42a1fa00f02b345a3e7342c52dbb620d06ad5361a" => :mojave
    sha256 "92337a1ca119b077911dfe28941c84f31b1f78cff6ece4a199c3ff4562951492" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats; <<~EOS
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
