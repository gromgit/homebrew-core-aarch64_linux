class Enkits < Formula
  desc "C and C++ Task Scheduler for creating parallel programs"
  homepage "https://github.com/dougbinks/enkiTS"
  url "https://github.com/dougbinks/enkiTS/archive/refs/tags/v1.11.tar.gz"
  sha256 "b57a782a6a68146169d29d180d3553bfecb9f1a0e87a5159082331920e7d297e"
  license "Zlib"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/enkits"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8742e13a932c3751e5dac800935f8b72a655d53ac9ba97dbe9c27c99b22a8e80"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DENKITS_BUILD_EXAMPLES=OFF
      -DENKITS_INSTALL=ON
      -DENKITS_BUILD_SHARED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install_symlink "#{lib}/enkiTS/#{shared_library("libenkiTS")}"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/PinnedTask.cpp",
      "-std=c++11", "-I#{include}/enkiTS", "-L#{lib}", "-lenkiTS", "-o", "example"
    output = shell_output("./example")
    assert_match("This will run on the main thread", output)
    assert_match(/This could run on any thread, currently thread \d/, output)
  end
end
