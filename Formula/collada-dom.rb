class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 4
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2c5fc66501eb69de970b7669e4aabb118bc677bb3864ccb5bdc0088c4912ffeb"
    sha256 cellar: :any,                 arm64_big_sur:  "393c48aed410113fd631b7f3fb986532f0a9312b06c91e17a52195e3a6bcf537"
    sha256 cellar: :any,                 monterey:       "26c7075d19926064efdb4d1f20857c755791d0f5a6039a573f6fdfc66e0e41f9"
    sha256 cellar: :any,                 big_sur:        "c0da851d193374fc5facfcc9c2bd7ddc5de7c92f224d4e7a1d921017ec9e4508"
    sha256 cellar: :any,                 catalina:       "383e160c3c84dce95e7a819a7333b822ecc9395dcb41c008f966e266a2ebb34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7beae8c38b33043b5fbc1661d80a0855eef1c2025b7ab2f505190eb121ac569b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "minizip"
  depends_on "pcre"

  uses_from_macos "libxml2"

  def install
    # Remove bundled libraries to avoid fallback
    (buildpath/"dom/external-libs").rmtree

    ENV.cxx11 if OS.linux? # due to `icu4c` dependency in `libxml2`
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <dae.h>
      #include <dae/daeDom.h>

      using namespace std;

      int main()
      {
        cout << GetCOLLADA_VERSION() << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/collada-dom2.5",
                    "-L#{lib}", "-lcollada-dom2.5-dp", "-o", "test"

    # This is the DAE file version, not the package version
    assert_equal "1.5.0", shell_output("./test").chomp
  end
end
