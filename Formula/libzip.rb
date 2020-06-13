class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.7.1.tar.xz"
  sha256 "a020dc1b17a79faa748e43a05f8605d65e403813e8e97ad3a300a90ddba097ac"

  bottle do
    sha256 "a5e946984fe35dbbceb39dbb2a68e781cb3c7d7df642b5e0024e87e4dd211f26" => :catalina
    sha256 "8799d573ede87e67c7498e12e63a4ec9deac4ee2e76d51303c59f71350597d1b" => :mojave
    sha256 "4cf3e50e427b704125978eddddc4bd64e67d2631f54c4fd7990503a8b07dff57" => :high_sierra
  end

  depends_on "cmake" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  conflicts_with "libtcod", "minizip2",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match /\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1)
  end
end
