class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.9.1/SHTOOLS-4.9.1.tar.gz"
  sha256 "5c22064f9daf6e9aa08cace182146993aa6b25a6ea593d92572c59f4013d53c2"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "19803fdcf199d7c5a374a9547d11b3cf3dd645f06dba787a8652148f72d247d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a9fd37585d31ef6f1c61b431bfab4fde9755db5ee081d8eba1c9a358278481f"
    sha256 cellar: :any_skip_relocation, catalina:      "99aea0397bae82f956eab6868704b493b99f9160e4c5f8f558937db3e349b96b"
    sha256 cellar: :any_skip_relocation, mojave:        "00f6302f52c6df51ee3477d0c05d66c1a1feec59a4b8883b2af53faa6a631e30"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

  def install
    system "make", "fortran"
    system "make", "fortran-mp"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp_r "#{share}/examples/shtools", testpath
    system "make", "-C", "shtools/fortran",
                   "run-fortran-tests-no-timing",
                   "F95=gfortran",
                   "F95FLAGS=-m64 -fPIC -O3 -std=gnu -ffast-math",
                   "MODFLAG=-I#{HOMEBREW_PREFIX}/include",
                   "LIBPATH=#{HOMEBREW_PREFIX}/lib",
                   "LIBNAME=SHTOOLS",
                   "FFTW=-L #{HOMEBREW_PREFIX}/lib -lfftw3 -lm",
                   "LAPACK=-L #{Formula["openblas"].opt_lib} -lopenblas",
                   "BLAS="
  end
end
