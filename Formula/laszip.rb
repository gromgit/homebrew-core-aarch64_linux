class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://laszip.org/"
  url "https://github.com/LASzip/LASzip/releases/download/3.4.3/laszip-src-3.4.3.tar.gz"
  sha256 "53f546a7f06fc969b38d1d71cceb1862b4fc2c4a0965191a0eee81a57c7b373d"
  license "LGPL-2.1-or-later"
  head "https://github.com/LASzip/LASzip.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/laszip"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5f7b7209b66ed1cdbb2a80961d5b2970c7f709e0831a56c559bdb890d54c8fae"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/laszipdllexample.cpp", "-L#{lib}",
                    "-llaszip", "-llaszip_api", "-Wno-format", "-ldl", "-o", "test"
    assert_match "LASzip DLL", shell_output("./test -h 2>&1", 1)
  end
end
