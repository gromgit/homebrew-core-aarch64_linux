class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.7.0-source.tgz"
  sha256 "e27f32f92b374ba2a746a9d9c496401c13f66ac6e3e70753e16fa4012d14320e"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "5f0bbb6fd95e78eeaa618f6eeb505e60186cef1576a1cb571db6e266c19c410c" => :big_sur
    sha256 "bacc0f9b240d5dcdeaa7940e8504f84646f6b45e3a3ce98e193d8c508c057bb3" => :catalina
    sha256 "576880fbd4644e857dcbc304669595906a4c21d4bdbf98afb45f0fc9dfcd9d81" => :mojave
    sha256 "74b1eaf6b6d0ce8aee44bca666f7cd18b73279b893c46fa9d3e480a07da8f0ba" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
    args = std_cmake_args + %W[
      -DENABLE_OS_SPECIFIC_INSTALL=0
      -DGMSH_BIN=#{bin}
      -DGMSH_LIB=#{lib}
      -DGMSH_DOC=#{pkgshare}/gmsh
      -DGMSH_MAN=#{man}
      -DENABLE_BUILD_LIB=ON
      -DENABLE_BUILD_SHARED=ON
      -DENABLE_NATIVE_FILE_CHOOSER=ON
      -DENABLE_PETSC=OFF
      -DENABLE_SLEPC=OFF
      -DENABLE_OCC=ON
    ]

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"

      # Move onelab.py into libexec instead of bin
      mkdir_p libexec
      mv bin/"onelab.py", libexec
    end
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/tutorial/t1.geo", "-parse_and_exit"
  end
end
