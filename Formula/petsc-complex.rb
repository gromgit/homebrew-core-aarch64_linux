class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.14.4.tar.gz"
  sha256 "b030969816e02c251a6d010c07a90b69ade44932f9ddfac3090ff5e95ab97d5c"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 arm64_big_sur: "e979a889e1c6c17fde16b1b23cdc6a1e331f6593de530755481cd962d1d16bbd"
    sha256 big_sur:       "9520a89e10a7d920086d2ec80d1a52f53e2fb7d891831f1815485df29b4dfc65"
    sha256 catalina:      "4125f60243d7e28bc051d4d2554d18d2dc1c1f002bb55de889d09d4e499c48fb"
    sha256 mojave:        "d94ad061ec2daf07f74b827ce9ff9b1bdb202d60a6379c6bf3b1707a337f695b"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-x=0",
                          "--CC=mpicc",
                          "--CXX=mpicxx",
                          "--F77=mpif77",
                          "--FC=mpif90",
                          "MAKEFLAGS=$MAKEFLAGS"
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm_f lib/"petsc/conf/configure-hash"
    inreplace lib/"petsc/conf/petscvariables", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
  end

  test do
    test_case = "#{share}/petsc/examples/src/ksp/ksp/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
