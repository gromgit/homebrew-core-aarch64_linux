class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.7.1.tar.xz"
  sha256 "a020dc1b17a79faa748e43a05f8605d65e403813e8e97ad3a300a90ddba097ac"

  bottle do
    sha256 "d117bca0832ea1c01d4b5e4797dc48aa6daf8d3424fc22296106fb513b65c338" => :catalina
    sha256 "2640af399ccf6a431800ba2d893b9ca776df371f252df931c785e4ef33b66940" => :mojave
    sha256 "b03e30204741a9638a81c1cff253f97f3b4eb19a49a0f9dfeb542d32cfca60b7" => :high_sierra
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
