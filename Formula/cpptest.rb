class Cpptest < Formula
  desc "Unit testing framework handling automated tests in C++"
  homepage "https://cpptest.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cpptest/cpptest/cpptest-2.0.0/cpptest-2.0.0.tar.bz2"
  mirror "https://github.com/cpptest/cpptest/releases/download/2.0.0/cpptest-2.0.0.tar.bz2"
  sha256 "7c258936a407bcd1635a9b7719fbdcd6c6e044b5d32f53bbf6fbf6f205e5e429"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cpptest"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6da3e59d0f0d8bd18d3b4d50742b3906962a0092eeb1d51f581d80b930797c11"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <cpptest.h>

      class TestCase: public Test::Suite
      {
      public:
        TestCase() { TEST_ADD(TestCase::test); }
        void test() { TEST_ASSERT(1 + 1 == 2); }
      };

      int main()
      {
        TestCase ts;
        Test::TextOutput output(Test::TextOutput::Verbose);
        assert(ts.run(output));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lcpptest", "-o", "test"
    system "./test"
  end
end
