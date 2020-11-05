class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.15.0.tar.gz"
  sha256 "11e70eee6408ffe1fdb039599185c7e5c4b06df9fd2c120fc31c9959146579f5"
  license "BSD-3-Clause"
  head "https://github.com/mlpack/ensmallen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54cacad71c391212c8410d999ac81a19760b08806f77c9bba3fb53ac29fde8e0" => :catalina
    sha256 "6a83ed4a7d4d3545e428630e879a654d10e36446e6f1d03b1ec4543fc2fc516b" => :mojave
    sha256 "accb89456bb9d0a77a212d347708dd360e6fc4376d7b69846232c71a0d1cd46e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "armadillo"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ensmallen.hpp>
      using namespace ens;
      int main()
      {
        test::RosenbrockFunction f;
        arma::mat coordinates = f.GetInitialPoint();
        Adam optimizer(0.001, 32, 0.9, 0.999, 1e-8, 3, 1e-5, true);
        optimizer.Optimize(f, coordinates);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                    "-o", "test"
  end
end
