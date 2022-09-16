class Pagmo < Formula
  desc "Scientific library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.18.0.tar.gz"
  sha256 "5ad40bf3aa91857a808d6b632d9e1020341a33f1a4115d7a2b78b78fd063ae31"
  license any_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9fdeb12b0f2606287dd1e2032da47a63c84702b3b983ea502fa258ef8ccd2c46"
    sha256 cellar: :any,                 arm64_big_sur:  "c47c61282421e3ca6dcc9b0c3506860d79283a3612eb2307f52292c48e423986"
    sha256 cellar: :any,                 monterey:       "76a1ef6baf81a36641d9ded41378f20f4a528f378e289d9d4c03396143fd49bc"
    sha256 cellar: :any,                 big_sur:        "3c13ea41cb30df2fdb763fce03b402ee38c0a44a48eb41374dda972ca19786f0"
    sha256 cellar: :any,                 catalina:       "5ec05fbd452a6bd80feaab0e4030ad8e2ff5d29e5e895779171118ea7bada8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "167678b868dc7796bbe34aa805d657b2012bcf6c413594e1dbff9e190dbe57fb"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "nlopt"
  depends_on "tbb"

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DPAGMO_WITH_EIGEN3=ON", "-DPAGMO_WITH_NLOPT=ON",
                         *std_cmake_args,
                         "-DCMAKE_CXX_STANDARD=17"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>

      #include <pagmo/algorithm.hpp>
      #include <pagmo/algorithms/sade.hpp>
      #include <pagmo/archipelago.hpp>
      #include <pagmo/problem.hpp>
      #include <pagmo/problems/schwefel.hpp>

      using namespace pagmo;

      int main()
      {
          // 1 - Instantiate a pagmo problem constructing it from a UDP
          // (i.e., a user-defined problem, in this case the 30-dimensional
          // generalised Schwefel test function).
          problem prob{schwefel(30)};

          // 2 - Instantiate a pagmo algorithm (self-adaptive differential
          // evolution, 100 generations).
          algorithm algo{sade(100)};

          // 3 - Instantiate an archipelago with 16 islands having each 20 individuals.
          archipelago archi{16u, algo, prob, 20u};

          // 4 - Run the evolution in parallel on the 16 separate islands 10 times.
          archi.evolve(10);

          // 5 - Wait for the evolutions to finish.
          archi.wait_check();

          // 6 - Print the fitness of the best solution in each island.
          for (const auto &isl : archi) {
              std::cout << isl.get_population().champion_f()[0] << std::endl;
          }

          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lpagmo",
                    "-std=c++17", "-o", "test"
    system "./test"
  end
end
