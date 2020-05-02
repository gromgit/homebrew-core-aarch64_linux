class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-05-01.tar.gz"
  version "20200501"
  sha256 "88864d7f5126bb17daa1aa8f41b05599aa6e3222e7b28a90e372db53c1c49aeb"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "d813a9eedba207c59de4aab1cca479f70258c4b700ab0ba9375d6e22d4f61c24" => :catalina
    sha256 "176c60943a53680b6d0ef31a97ab676233de964e67786fa746ea427fa678588e" => :mojave
    sha256 "f877947838db370c6be899383ddde1f2058e2b55cdddfd933fd98d4bc9d0ef82" => :high_sierra
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.7.0.0.dylib", "#{lib}/libre2.0.dylib")
    lib.install_symlink "libre2.7.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.7.0.0.dylib" => "libre2.dylib"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
