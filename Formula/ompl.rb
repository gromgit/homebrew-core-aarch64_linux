class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/1.5.2.tar.gz"
  sha256 "db1665dd2163697437ef155668fdde6101109e064a2d1a04148e45b3747d5f98"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(%r{href=.*?/ompl/ompl/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8c0d6f9594ce11936ab9e26625d89bb33dce3ff8b6795c706e540215c0f3c152"
    sha256 cellar: :any,                 arm64_big_sur:  "20365e1b7edded4f8cd3afd5d5930c05fdd9b1607cb49a66e659fc780b2cba23"
    sha256 cellar: :any,                 monterey:       "c0e1c146155afa48941aab7ab5a0aea8fa2402b5849492274bca94594562490c"
    sha256 cellar: :any,                 big_sur:        "eb74697504d54cdd7b3c215c8ce226c5490a873a81d265d3b45a56c5b388d982"
    sha256 cellar: :any,                 catalina:       "6632b384fe0325d6bf078ac1bd57c10e2b07737a208d490f6a579398b971b9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b6327fa3e8ae84fe376c1ac97a1aeacf3d2fe444d253a67b2d3193eafe04379"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "ode"

  def install
    ENV.cxx11
    args = std_cmake_args + %w[
      -DOMPL_REGISTRATION=OFF
      -DOMPL_BUILD_DEMOS=OFF
      -DOMPL_BUILD_TESTS=OFF
      -DOMPL_BUILD_PYBINDINGS=OFF
      -DOMPL_BUILD_PYTESTS=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_spot=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Triangle=ON
    ]
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}/ompl-1.5", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end
