class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.57b.tar.gz"
  version "2.57b"
  sha256 "6f05a6515c07abe49f6f292bd13c96004cc1e016bda0c3cc9c2769dd43f163ee"
  license "Apache-2.0"
  revision 1

  deprecate! date: "2022-09-17", because: :repo_archived

  depends_on arch: :x86_64

  def install
    system "make", "PREFIX=#{prefix}", "AFL_NO_X86=1"
    system "make", "install", "PREFIX=#{prefix}", "AFL_NO_X86=1"

    # Delete incompatible elf32-i386 testcase file
    rm Dir[share/"afl/**/elf/small_exec.elf"]
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    cmd = if OS.mac?
      "afl-clang++"
    else
      "afl-g++"
    end
    system bin/cmd, "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
