class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.17.5.tar.gz"
  sha256 "a60be1e729de9cf32e2a10335679f311228d8f04997b57d5dcbb508acfe29bed"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "7381c914063cfdf1bf8bae87db703cd08852d4c4404a1bda1aed0ff61f6e73bf" => :catalina
    sha256 "62bd03d54ab09b73df5ded4472ef155a010cddce1127cc6e36ba26a766016617" => :mojave
    sha256 "a7bf159890ed0df47fb59a94ee5d196187cc5ee18a2488516afe0ccb9fc2b948" => :high_sierra
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
