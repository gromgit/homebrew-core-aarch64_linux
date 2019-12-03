class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "https://laszip.org/"
  url "https://github.com/LASzip/LASzip/releases/download/3.4.3/laszip-src-3.4.3.tar.gz"
  sha256 "53f546a7f06fc969b38d1d71cceb1862b4fc2c4a0965191a0eee81a57c7b373d"
  head "https://github.com/LASzip/LASzip.git"

  bottle do
    sha256 "7779ef145383b44244ad5cac6e46e5ef003fe99b4406dcdec9f14aa757511c99" => :catalina
    sha256 "bb1b85c70f7efee68cac94ed831941fe1420530f36166587a8715ec5507330eb" => :mojave
    sha256 "a9396e0e7d10b57df846c73fcfe807d354a1aab80f5b0c85fb6a68b420db00aa" => :high_sierra
    sha256 "7148c262d7dd9e0d9889aebc5fb38f3b12954e74b716fa7b65cb5550350ee196" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/laszipdllexample.cpp", "-L#{lib}",
                    "-llaszip", "-llaszip_api", "-Wno-format", "-o", "test"
    assert_match "LASzip DLL", shell_output("./test -h 2>&1", 1)
  end
end
