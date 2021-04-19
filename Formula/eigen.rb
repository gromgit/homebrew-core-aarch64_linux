class Eigen < Formula
  desc "C++ template library for linear algebra"
  homepage "https://eigen.tuxfamily.org/"
  url "https://gitlab.com/libeigen/eigen/-/archive/3.4/eigen-3.4.tar.gz"
  sha256 "168ff8511e817b250fac6add306d18e677f67342f3c2f10a0fb8f59d437c7f47"
  license "MPL-2.0"
  head "https://gitlab.com/libeigen/eigen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f174be279eca5ab7df15c762ee5b7562b1d921496616127c7805b14b7282fea2"
    sha256 cellar: :any_skip_relocation, big_sur:       "60e2816081c5ac57028ab360ba682b2cabce5d04dd942f9c19d9b9cb26a0fcd6"
    sha256 cellar: :any_skip_relocation, catalina:      "60e2816081c5ac57028ab360ba682b2cabce5d04dd942f9c19d9b9cb26a0fcd6"
    sha256 cellar: :any_skip_relocation, mojave:        "18c46f8fd607822f8da37d684f7e8c40e45567c89cd31a3008cfa6b78b43783b"
  end

  depends_on "cmake" => :build

  conflicts_with "freeling", because: "freeling ships its own copy of eigen"

  def install
    mkdir "eigen-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make", "install"
    end
    (share/"cmake/Modules").install "cmake/FindEigen3.cmake"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <Eigen/Dense>
      using Eigen::MatrixXd;
      int main()
      {
        MatrixXd m(2,2);
        m(0,0) = 3;
        m(1,0) = 2.5;
        m(0,1) = -1;
        m(1,1) = m(1,0) + m(0,1);
        std::cout << m << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/eigen3", "-o", "test"
    assert_equal %w[3 -1 2.5 1.5], shell_output("./test").split
  end
end
