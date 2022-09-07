class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.10.1-source.tgz"
  sha256 "d086d581aa27e491a35fead2b9753d4c2065e67984af12a891d8541391209bf9"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d6500fa8dd44864115eb53849c0281068df2fa88b0a78994a0adaebb478cf2f5"
    sha256 cellar: :any,                 arm64_big_sur:  "f34436491b4b9ca21383b517c65b8f39e27d37a2fce3f48199db72ae4144f1b6"
    sha256 cellar: :any,                 monterey:       "e32b777076b17f559cf7added72bbb47599c0a93d2e64d11308cc6bb3b77c689"
    sha256 cellar: :any,                 big_sur:        "53c572c8215803c87b7318593b9bdfe6235f543ee8a0a20884a7a42e956b1fad"
    sha256 cellar: :any,                 catalina:       "2fa85820cf20997b957f9fd52a340b7a64ac8973d21f92e35ed284d2309f4381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc374c7e645f4cc3a069ed68d16d95b4160bf7a3fe4e807cd49077a2d2972356"
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
    system "#{bin}/gmsh", "#{share}/doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end
