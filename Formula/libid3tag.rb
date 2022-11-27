class Libid3tag < Formula
  desc "ID3 tag manipulation library"
  homepage "https://www.underbit.com/products/mad/"
  url "https://github.com/tenacityteam/libid3tag/archive/refs/tags/0.16.2.tar.gz"
  sha256 "96198b7c8803bcda44e299615e1929a85bd5a5da02e67ebc442735bc50018190"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libid3tag"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8d5ffc15cd869ad76318d7b3a8d9962b28bd63486a140ca0eae85696013f6351"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  uses_from_macos "gperf"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <id3tag.h>

      int main(int n, char** c) {
        struct id3_file *fp = id3_file_open("#{test_fixtures("test.mp3")}", ID3_FILE_MODE_READONLY);
        struct id3_tag *tag = id3_file_tag(fp);
        struct id3_frame *frame = id3_tag_findframe(tag, ID3_FRAME_TITLE, 0);
        id3_file_close(fp);

        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs id3tag").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
