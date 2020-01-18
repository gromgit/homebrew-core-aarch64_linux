class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.11.2.tar.gz"
  sha256 "314045d7d63997deb0ea36d0046506569aff58fa7dbd54ffaff5f9ba78ff5ff8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e31fcc53d0cbfc104533eee9a504ee4adc9f193876aadab246db45139d1043f7" => :catalina
    sha256 "e31fcc53d0cbfc104533eee9a504ee4adc9f193876aadab246db45139d1043f7" => :mojave
    sha256 "e31fcc53d0cbfc104533eee9a504ee4adc9f193876aadab246db45139d1043f7" => :high_sierra
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
    cxx_with_flags = ENV.cxx.split + ["test.cpp",
                                      "-std=c++11",
                                      "-I#{include}",
                                      "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                                      "-o", "test"]
    system *cxx_with_flags
  end
end
