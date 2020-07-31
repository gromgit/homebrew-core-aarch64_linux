class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.2.0.tar.gz"
  sha256 "d27caf80bbd560c8a642d9911b285bb3ace6076d2874f9dbb7436ea79292efec"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "39678d7d1bf583fc5c5812a7dff8626a8a5d4ca8028fb0b8b30a74fafcca82a8" => :catalina
    sha256 "7c8e7fe9a642ba2e33c0e25b702171b557f29a3dd37921826d16566a0417cf66" => :mojave
    sha256 "d961682c43b33f7149ed477bdff2246a6449463a2f51c592501eec7096dbbd11" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
