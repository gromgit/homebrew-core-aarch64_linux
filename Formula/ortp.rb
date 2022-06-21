class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.45/ortp-5.1.45.tar.bz2"
  sha256 "2f6bd8735e94e532567e53db02488c430a0184596d9dd9e0b063d2e7d841a35e"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "92ae182f9a7565ef4e6328bdf0781afbdfbf7bc9c29074eff1c974901cdaeaa6"
    sha256 cellar: :any,                 arm64_big_sur:  "9a8b65cfabb0f1f7aae4d93db7e4d437393295f216b273eacdf44cf5fa672b90"
    sha256 cellar: :any,                 monterey:       "cf047f31406349e1e2445fa4f49beeb4252daadf2265ee900f297eb6de73478d"
    sha256 cellar: :any,                 big_sur:        "146eca32396fbcd4a0c64c2a6aa67b865003507a7c06c5a038658232f1f09c40"
    sha256 cellar: :any,                 catalina:       "26dfee941c738d2b3747118869fbdada57137ea9e812c6e86f3974ebf84e989f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16242c2ea4ba2cc0af05d7fc5d22dd0f0ff9bf46817cad1be192117b2ea3a085"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.32/bctoolbox-5.1.45.tar.bz2"
    sha256 "d8a1374c36cedc0dfc09fe6a67075b55c13006386c466413a6af29941e9e7e65"
  end

  def install
    resource("bctoolbox").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: libexec), "-DENABLE_TESTS_COMPONENT=OFF"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?

    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=-I#{libexec}/include
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
