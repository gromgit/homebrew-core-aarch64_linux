class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.17.6.tar.gz"
  sha256 "2a39beed5b10a7632b9501317d16d9460da8dc303a4c3e7a30cb72f87b612440"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "f7edfd696aeb6da9b5648198f012848abcbdcfef7563d33a5dcfa7fa5d00f3e7" => :catalina
    sha256 "4e94b6afe4bf7e9c61e368c75348f667168dbdf6d0b1400163e7c9cc83ad1f68" => :mojave
    sha256 "7e72d56ec3a0119e2a2d141e1373e1977c2315efcb18b34261af3d863be39331" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--build-static",
                          "--no-examples",
                          "--no-unit-tests",
                          "--no-opencl"
    system "make", "--directory=build", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
