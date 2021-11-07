class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.11.tar.gz"
  sha256 "1389100ca132e06455ad7e4e765a045d9821c234f6e388bef6a0c8d610ce36d1"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d4ab80277ccfddab08c9164da4f4493553b16516b27c2f11dc1d50dc394eecf1"
    sha256 cellar: :any,                 arm64_big_sur:  "16dbf7e9385bb596654f6ce8218fd28cd6623c7ae87bd1c14ad26b5726b9b20c"
    sha256 cellar: :any,                 monterey:       "d50433de8de6abd02c75b84b209a2e33b136b449a663a268bc41e2e2e0d3e097"
    sha256 cellar: :any,                 big_sur:        "d2f0b7ac1fc3b350fd6d8b1e6c15e1bd79b61d623098dc21eee6420638de2e56"
    sha256 cellar: :any,                 catalina:       "13050963df317b4e65a3ba224ee270f67a7cc39191b3dee5546e5bdb54a97318"
    sha256 cellar: :any,                 mojave:         "c707921fb22d6c89579630c365fe5d60b5ee24d9cc017e05e1d82688a6e891c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67725e7e2de723c3d643530c6815a27322c1df6b46ed482d8c89b01b0add2988"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end
