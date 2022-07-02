class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.07.tar.gz"
  sha256 "591c8bf63873856d051d4ba8ff4a43e853391465d4eacd164c1d10898d848d04"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0a9e88769b4a8ce4e117942e7b4f9802a13514e9cb79dc4490a0402576482ae7"
    sha256 cellar: :any,                 arm64_big_sur:  "bebbe0a403b56b3412e346feab8681f1b369cd532243f9f7442869b5102c6d62"
    sha256 cellar: :any,                 monterey:       "8a74cf44487624760a6e87adf68d5798117ea6c310a0be99a67ebf5ce7d6dfd0"
    sha256 cellar: :any,                 big_sur:        "1a3ec49ddd79a52a30bd2af27aabae37ec04ad273640bf3e95ad73a9de877d6f"
    sha256 cellar: :any,                 catalina:       "9a127f114dcf6a3ad22381df2e937fa6081e5473a91b90f80cb4820c63e0b175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eadac57e7a7c50b67af5a2a2fbbdf2b3769c406939c6fd1261905135fc5c413"
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
