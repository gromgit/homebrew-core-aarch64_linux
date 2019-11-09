class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.12.1.tar.gz"
  sha256 "28c25cde288f689605f2160613feef45863c9ef3ceb2d1a44c2226b779938781"

  bottle do
    sha256 "80944d903c5bc1559ec7e4ed85c837bc781e4560e39a6c1d29b77505a2bd5c58" => :catalina
    sha256 "fbd0b55648dafc969b6dbe5622ed7603cf468e3f4fd6f85f7d0470437fb7fe6a" => :mojave
    sha256 "861cbf763f1a233545a55df8adf4de4d5e5d70a13bcf68dae311dc96cc44192f" => :high_sierra
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc", :because => "petsc must be installed with either real or complex support, not both"

  def install
    ENV["CC"] = "mpicc"
    ENV["CXX"] = "mpicxx"
    ENV["F77"] = "mpif77"
    ENV["FC"] = "mpif90"
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-x=0"
    system "make", "all"
    system "make", "install"
  end

  test do
    test_case = "#{share}/petsc/examples/src/ksp/ksp/examples/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match /^Norm of error .+, Iterations/, line, "Unexpected output format"
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
