class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  url "https://github.com/facebook/fbthrift/archive/v2022.09.26.00.tar.gz"
  sha256 "f64ff5835986cec70c7c860b3dec5b80f195f0d318893da93136276e77f3ef15"
  license "Apache-2.0"
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f0b623506649b1e6c0fc81188688d6a06dd2fdb5f30f82d664a1990717225345"
    sha256 cellar: :any,                 arm64_big_sur:  "b7a745d2034b63c5418a5264c95ee05f6acc27ae675e7164f0cfc6911049b7ce"
    sha256 cellar: :any,                 monterey:       "e5c01378593b5603b2d28c362a6a9b3491a5145e5963896a7ed40c0d2d7427d7"
    sha256 cellar: :any,                 big_sur:        "4cf6e8bba1837fd8cb2ee6d12464fe5b3bbfa00351f8a9b01b353e66be68bfa0"
    sha256 cellar: :any,                 catalina:       "33f27cd98d1d152f5fd0bcea348f36e1b29ba5e8d11045de99356ff974cec52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e5019f1366a412bb8f6dba3f88ab9a9c2b872f4bfaff8300a3f1e12d6e70a7"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: 'asm goto' constructs are not supported yet
    EOS
  end

  fails_with gcc: "5" # C++ 17

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build/shared", *std_cmake_args, *shared_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"
  end

  test do
    (testpath/"example.thrift").write <<~EOS
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    EOS

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_predicate testpath/"gen-cpp2", :exist?
    assert_predicate testpath/"gen-cpp2", :directory?
  end
end
