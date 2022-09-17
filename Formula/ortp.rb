class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.61/ortp-5.1.61.tar.bz2"
  sha256 "028d4c60a55814786d8a13f99b21ca86b9b5ff229a579fe5fea8d40b0d135319"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a7957cf8af01767ea9ea3c3ece09bcb3365cbe73c02941e2ac59cfae544e9a7a"
    sha256 cellar: :any,                 arm64_big_sur:  "45fc44eaa628a46d30063804099b01f55bf16181c0352f54b04a4d4a6769a753"
    sha256 cellar: :any,                 monterey:       "7d58d6515059359e6bc0cff8222aebb9509178cae528d25a23851b75fd9f8ce0"
    sha256 cellar: :any,                 big_sur:        "2a1e737533f32b5c2573c9a5065493f7ca34700aa3994545a178459012ad3e11"
    sha256 cellar: :any,                 catalina:       "8223016e6e30bc6312b0d6cc7656dcb18d0b0c1ee07fdad3f380e81afb96dd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0ba1503878d27abde9861a092c791a3458c18984e6d42c7f3670272ab26d67c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.61/bctoolbox-5.1.61.tar.bz2"
    sha256 "bba827cbc32e314749fcdd986a5a36c9720f70c2478e7bfc4c1ab2966cdc523c"
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
