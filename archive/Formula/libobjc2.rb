class Libobjc2 < Formula
  desc "Objective-C runtime library intended for use with Clang"
  homepage "https://github.com/gnustep/libobjc2"
  url "https://github.com/gnustep/libobjc2/archive/refs/tags/v2.1.tar.gz"
  sha256 "78fc3711db14bf863040ae98f7bdca08f41623ebeaf7efaea7dd49a38b5f054c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libobjc2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ba3de2eab8c8b5a07a7746c6430c6d4f5ddccc752814f82902d4b80c381ea662"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  # Clang explicitly forbids building Mach-O binaries of libobjc2.
  # https://reviews.llvm.org/D46052
  # macOS provides an equivalent Objective-C runtime.
  depends_on :linux

  # While libobjc2 is built with clang, it does not use any LLVM runtime libraries.
  uses_from_macos "llvm" => [:build, :test]

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  resource "robin-map" do
    url "https://github.com/Tessil/robin-map/archive/refs/tags/v1.0.1.tar.gz"
    sha256 "b2ffdb623727cea852a66bddcb7fa6d938538a82b40e48294bb581fe086ef005"
  end

  def install
    (buildpath/"third_party/robin-map").install resource("robin-map")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Change Objective-C header path which assumes tests are being run in source tree.
    inreplace ["Test/Test.h", "Test/Test.m"], "../objc", "objc"
    pkgshare.install "Test"
  end

  test do
    # ENV.cc returns llvm_clang, which does not work in a test block.
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"

    # Copy over test library and header and runtime test.
    cp pkgshare/"Test/Test.h", testpath
    cp pkgshare/"Test/Test.m", testpath
    cp pkgshare/"Test/RuntimeTest.m", testpath

    # First build test shared library and then link it to RuntimeTest.
    pkg_config_flags = Utils.safe_popen_read("pkg-config", "--cflags", "--libs", "libobjc").chomp.split
    system ENV.cc, "Test.m", "-fobjc-runtime=gnustep-2.0", *pkg_config_flags,
                   "-fPIC", "-shared", "-o", "libTest.so"
    system ENV.cc, "RuntimeTest.m", "-fobjc-runtime=gnustep-2.0", *pkg_config_flags, "-Wl,-rpath,#{lib}",
                   "-L#{testpath}", "-Wl,-rpath,#{testpath}", "-lTest", "-o", "RuntimeTest"

    # RuntimeTest deliberately throws a test exception and outputs this to stderr.
    assert_match "in flight exception", shell_output("#{testpath}/RuntimeTest 2>&1")
  end
end
