class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/20220000.4.tar.gz"
  sha256 "0f4e11f20f8436b2d04522b1279f0ed335b28f454e71425ecf39106497363cb4"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cppad"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5dd5ab030d7ae92c2e87a19c9c5e08cc2a03586fdc9cd4580933b7628c84f8f7"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-Dcppad_prefix=#{prefix}"
      system "make", "install"
    end

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
