class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.64/ortp-5.1.64.tar.bz2"
  sha256 "0e558a70697fab0c9aa395b789ca0230a41c737b5d9259a49b377132cdd7c42c"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6be3da17fadbbd029be5692e415806027ed546329f293e6cadd806779b5091f1"
    sha256 cellar: :any,                 arm64_big_sur:  "4ceb275655a92e1c3d9c27e7578cc5d3e1457e06c3078b75c7a11e0039140fb3"
    sha256 cellar: :any,                 monterey:       "f945c213add5f11040809240674e770b6a921f751c4cbb2b315953c50682b195"
    sha256 cellar: :any,                 big_sur:        "5017c9b6ccb00d7d53e4a84d61750cc453a0a5bb44ffa69508ab069e0dd0f4b5"
    sha256 cellar: :any,                 catalina:       "021989a67c3498d6f9b5288640bc3a01263dbd6993859d70220d9a0764a35c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f8bd1732268d262770c65d033a261a959900766fed4fc8b1befd00bafb555e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.64/bctoolbox-5.1.64.tar.bz2"
    sha256 "c8a73e92e5ef0cb21362c4cda904ca1c4dcb4b831cf8fd24b57159dc265255d0"
  end

  def install
    resource("bctoolbox").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DENABLE_TESTS_COMPONENT=OFF",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    cflags = ["-I#{libexec}/include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
