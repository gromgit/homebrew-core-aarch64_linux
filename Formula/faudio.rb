class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.09.tar.gz"
  sha256 "b7833a0d095bef68cf5c56418e216e96f0f33452ef7d73cb8a4e37a54a74d977"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b87cfac90a0e68ef0fb9069d0a9a86101f9c41c722398b1818ef85a0d448914"
    sha256 cellar: :any,                 arm64_big_sur:  "d0ce04a9b3945b0d578308fbb72dcd3165b50fd5de98f72d584b37472bbe2879"
    sha256 cellar: :any,                 monterey:       "ffc2b8d987a07cc136e87274460b628829a8634f4a5b846cc70ba783ce8d8635"
    sha256 cellar: :any,                 big_sur:        "3913c5de9a877dd1681cd56e71aa861e6befc2e49b830a61bb9ad655c6abdebc"
    sha256 cellar: :any,                 catalina:       "c487040023ea039fa45fcd7265123e9bf11207ca090d3f1205927c23b8f5d453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c456f465bef1b173ca9bd42f2e8af803cff93f4c15fe8804a7d69084f47f4183"
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
