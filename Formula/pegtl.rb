class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/3.2.7.tar.gz"
  sha256 "d6cd113d8bd14e98bcbe7b7f8fc1e1e33448dc359e8cd4cca30e034ec2f0642d"
  license "BSL-1.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pegtl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6ace8be1e11acef6ecf8edd2c38b26c04a1f6c2fdde528e24ced956298db798d"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DPEGTL_BUILD_TESTS=OFF",
                            "-DPEGTL_BUILD_EXAMPLES=OFF",
                            "-DCMAKE_CXX_STANDARD=17"
      system "make", "install"
    end
    rm "src/example/pegtl/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example/pegtl").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++17", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
