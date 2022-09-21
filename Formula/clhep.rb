class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.5.3.tgz"
  sha256 "45f63eeb097f02fe67b86a7dadbf10d409b401c28a1a3e172db36252c3097c13"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/clhep"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9d98835929dd22c07aed5f38d6dc73ab36b853a82ff201306932e28d458f07a2"
  end


  depends_on "cmake" => :build

  def install
    (buildpath/"CLHEP").install buildpath.children if build.head?
    system "cmake", "-S", "CLHEP", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end
