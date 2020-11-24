class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.7.3/arrayfire-full-3.7.3.tar.bz2"
  sha256 "523194f36ddba346d81c935b5f441f28af97e7454fd4196f3a6dfbf8d170e88b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "bd0155cbacbdae4aefc106eebcc698c01c1f12e863b2e904b39b74ea8c1e262c" => :big_sur
    sha256 "ede6ece8582145d943499e3679dfa19858022b1e5662076940249c27ccbe3f49" => :catalina
    sha256 "710d8a0f9536955e2734c9932317b8b30af90a7741c1fd03b0ec1b65db206167" => :mojave
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "openblas"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DAF_BUILD_CUDA=OFF"
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
