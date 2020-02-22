class Ensmallen < Formula
  desc "Flexible C++ library for efficient mathematical optimization"
  homepage "https://ensmallen.org"
  url "https://github.com/mlpack/ensmallen/archive/2.11.3.tar.gz"
  sha256 "52ddd26549ae014423d07c5ef8f1f418dc2cdfaa00e093db58392818154ce7f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "378eb54b3038b432e1a179c154f86beb43df1301a382eaed8ccab2afdecb7251" => :catalina
    sha256 "378eb54b3038b432e1a179c154f86beb43df1301a382eaed8ccab2afdecb7251" => :mojave
    sha256 "378eb54b3038b432e1a179c154f86beb43df1301a382eaed8ccab2afdecb7251" => :high_sierra
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
