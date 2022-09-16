class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.12.2.tar.gz"
  sha256 "db1b3ef888d37f0dbc567bc291ab2cdb5699172523a58dd5a5fe513ee38f83b0"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256                               arm64_monterey: "27be345f1467295f61a1be1489853445e50bb16823b730d45b784f550b7fe450"
    sha256                               arm64_big_sur:  "8ebb53e0628478a69c7ce30b803e46e497625a40778cafc8e4fd8a818c46636f"
    sha256                               monterey:       "a48b9ae2db6ee6ddd84bc0a273986fb1a263d13befa54569bd71e08415812e02"
    sha256                               big_sur:        "e6ffbd95e015ae79af3c98f3b57d2824b2e9914d336b4f4eb2d317ae1890bd43"
    sha256                               catalina:       "ecd278f70d04f92b8fecb69f01a550adba076e2f717c241647e5a8dc6a3f6a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e7eaaf0506baadc360af1162665c35c9ae829d81b3328676dd79a3fb3fc095e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "ipopt"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  fails_with gcc: "5"

  def install
    ENV.cxx11
    args = std_cmake_args

    if OS.mac?
      # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end

    mkdir "build" do
      system "cmake", "..", *args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}/doc/dart/**/CMakeFiles/"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system",
                    "-L#{Formula["libccd"].opt_lib}", "-lccd",
                    "-L#{Formula["fcl"].opt_lib}", "-lfcl",
                    "-std=c++14", "-o", "test"
    system "./test"
  end
end
