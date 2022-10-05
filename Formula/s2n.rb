class S2n < Formula
  desc "Implementation of the TLS/SSL protocols"
  homepage "https://github.com/aws/s2n-tls"
  url "https://github.com/aws/s2n-tls/archive/v1.3.24.tar.gz"
  sha256 "df6d2642e7b491f56110527bd73686d94ed3b186ff78d24e525cc0c3dd0d6b4b"
  license "Apache-2.0"
  head "https://github.com/aws/s2n-tls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "6ddda20e9b0d46c34066d0627c80002eb3463cf658ec36b65f6ea31b408eb3c0"
    sha256 cellar: :any,                 arm64_big_sur:  "ce8d25d2852881c66a17a0579573624d28e5d77a95c1e3b4273cb0bdf9b091d8"
    sha256 cellar: :any,                 monterey:       "a20c647fa71ceb6b1b01f8a7a6ba31e7f351b455e582eff2003847da80f044dd"
    sha256 cellar: :any,                 big_sur:        "d6a83ab93bda5b2df904991ddb3944166ec27e119f9c762cf42a2af83c35fbea"
    sha256 cellar: :any,                 catalina:       "d9a55131bf41fe76b9de2749cd34e58a23f8179a2871bf7cbad93e02624d48b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0106c0f8c75c709af06f9381dea0364b3646351f3baa5bcf1e74336762897c0f"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <s2n.h>
      int main() {
        assert(s2n_init() == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-ls2n", "-o", "test"
    ENV["S2N_DONT_MLOCK"] = "1" if OS.linux?
    system "./test"
  end
end
