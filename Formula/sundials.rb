class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computing.llnl.gov/projects/sundials"
  url "https://github.com/LLNL/sundials/releases/download/v6.2.0/sundials-6.2.0.tar.gz"
  sha256 "195d5593772fc483f63f08794d79e4bab30c2ec58e6ce4b0fb6bcc0e0c48f31d"
  license "BSD-3-Clause"

  livecheck do
    url "https://computing.llnl.gov/projects/sundials/sundials-software"
    regex(/href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c77ad026c0753be7749b297b1d1921af49134dae6c8ccb3eeb705e3efaefd0cc"
    sha256 cellar: :any,                 arm64_big_sur:  "cde3904eedbacf16fa230074549d7728dcb03345bdea7da67c637744b45b590d"
    sha256 cellar: :any,                 monterey:       "891690db69fc58e026bc1f4eca0109f1fc5f5c9889b7da5d12b9eb54a480dcae"
    sha256 cellar: :any,                 big_sur:        "a14e546867d769d774bcd5a6a723644cf1004a1627eb483bbeca143245c2834f"
    sha256 cellar: :any,                 catalina:       "32eb458bf6dc7fcb58336ed4af87de8686fce5d94a1df384a3a29496f1e1d47e"
    sha256 cellar: :any,                 mojave:         "5739a52fbed858b21ea5078f9371ce443476917552041efc16343c5fc4d48b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "909bc3b7d778f3e89f14738f7b2fa74940a4cd26dabb2bb63f652cf1c5fdc843"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"
  uses_from_macos "m4"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DBLA_VENDOR=OpenBLAS
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare/"examples").install Dir[prefix/"examples/nvector/serial/*"] \
                                  - Dir[prefix/"examples/nvector/serial/{CMake*,Makefile}"]
    (prefix/"examples").rmtree
  end

  test do
    cp Dir[pkgshare/"examples/*"], testpath
    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lsundials_nvecserial", "-lm"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./test 42 0")
  end
end
