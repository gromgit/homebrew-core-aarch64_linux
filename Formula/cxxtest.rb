class Cxxtest < Formula
  include Language::Python::Virtualenv

  desc "C++ unit testing framework similar to JUnit, CppUnit and xUnit"
  homepage "https://cxxtest.com/"
  url "https://github.com/CxxTest/cxxtest/releases/download/4.4/cxxtest-4.4.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cxxtest/cxxtest_4.4.orig.tar.gz"
  sha256 "1c154fef91c65dbf1cd4519af7ade70a61d85a923b6e0c0b007dc7f4895cf7d8"
  license "LGPL-3.0"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cxxtest"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4100f511ea81b952bfa19eb09a3cfb8654eb84657fbe2c8cb69ec6357b542f65"
  end

  depends_on "python@3.10"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.10"].opt_bin/"python3")
    venv.pip_install_and_link buildpath/"python"

    include.install "cxxtest"
    doc.install Dir["doc/*"]
  end

  test do
    testfile = testpath/"MyTestSuite1.h"
    testfile.write <<~EOS
      #include <cxxtest/TestSuite.h>

      class MyTestSuite1 : public CxxTest::TestSuite {
      public:
          void testAddition(void) {
              TS_ASSERT(1 + 1 > 1);
              TS_ASSERT_EQUALS(1 + 1, 2);
          }
      };
    EOS

    system bin/"cxxtestgen", "--error-printer", "-o", testpath/"runner.cpp", testfile
    system ENV.cxx, "-o", testpath/"runner", testpath/"runner.cpp"
    system testpath/"runner"
  end
end
