class Lmfit < Formula
  desc "C library for Levenberg-Marquardt minimization and least-squares fitting"
  homepage "https://jugit.fz-juelich.de/mlz/lmfit"
  url "https://jugit.fz-juelich.de/mlz/lmfit/-/archive/v9.0/lmfit-v9.0.tar.bz2"
  sha256 "773d8c9f8755727e70cb3e6b70069e3e0b7a3cb163183e44f2cff6dc1ea503fb"
  license "BSD-2-Clause"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "demo/curve1.c"
  end

  test do
    system ENV.cc, pkgshare/"curve1.c", "-I#{include}", "-L#{lib}", "-llmfit", "-o", "test"
    assert_match "converged  (the relative error in the sum of squares is at most tol)", shell_output("./test")
  end
end
