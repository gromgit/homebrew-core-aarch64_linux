class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.6.1.tar.gz"
  sha256 "4c06a9dc4017e8a2438ef80ee371d45868bda2237a98b26554de7a95406b283b"
  license all_of: ["MIT", "Unicode-DFS-2015"]

  bottle do
    cellar :any
    sha256 "ba7272b84ad108f17f1f129af117a3cba4cfa849915f532f7a145b1e2f97aecb" => :big_sur
    sha256 "9b73ad30c1de0f7b00754f844f146484443c258bfb1657aa0bbe57d3442b1dbc" => :catalina
    sha256 "d22e4fb3d9f59fbfe18ebda7cd3bd76b6e9acaefb75f7903e9fd00ce8d44a88e" => :mojave
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
