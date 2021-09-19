class Seal < Formula
  desc "Easy-to-use homomorphic encryption library"
  homepage "https://github.com/microsoft/SEAL"
  url "https://github.com/microsoft/SEAL/archive/v3.7.0.tar.gz"
  sha256 "06ea835d6c9cdbbc4edb72a8db4bd4b1115995f075774043b9f31938d0624543"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0584f2b09c2b026d8a792c6f12db824c1fe75e4a71ef3a9e5f009055928ca5ef"
    sha256 cellar: :any,                 big_sur:       "0891ff174a498115883c1acb680c5fe3af5468aeeb6bdaa743a410c567152f8e"
    sha256 cellar: :any,                 catalina:      "cd4065f8a7b4513c81baebbf75bf667cc109abb1ec53e4013a51995ad94c3363"
    sha256 cellar: :any,                 mojave:        "dc316b93b458de7e53b0e77b1e91d5c2cfd8a57f64a3a66b9807a00470c0e68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "200bbfba06fd7fb8af220837c5eae450c91870b0eb1925c5e67ce7153c7cffe0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "cpp-gsl"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "hexl" do
    url "https://github.com/intel/hexl/archive/v1.2.1.tar.gz"
    sha256 "d09f4bf5309f4fa13f0046475f77e8c5a065d7b9c726eba2d3d943fc13cdae1a"
  end

  def install
    if Hardware::CPU.intel?
      resource("hexl").stage do
        hexl_args = std_cmake_args + %w[
          -DHEXL_BENCHMARK=OFF
          -DHEXL_TESTING=OFF
          -DHEXL_EXPORT=ON
        ]
        system "cmake", "-S", ".", "-B", "build", *hexl_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
      ENV.append "LDFLAGS", "-L#{lib}"
    end

    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DSEAL_BUILD_DEPS=OFF
      -DSEAL_USE_ALIGNED_ALLOC=#{(MacOS.version > :mojave) ? "ON" : "OFF"}
      -DSEAL_USE_INTEL_HEXL=#{Hardware::CPU.intel? ? "ON" : "OFF"}
      -DHEXL_DIR=#{lib}/cmake
      -DCMAKE_CXX_FLAGS=-I#{include}
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"
    pkgshare.install "native/examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath

    # remove the partial CMakeLists
    File.delete testpath/"examples/CMakeLists.txt"

    # Chip in a new "CMakeLists.txt" for example code tests
    (testpath/"examples/CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.12)
      project(SEALExamples VERSION #{version} LANGUAGES CXX)
      # Executable will be in ../bin
      set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${SEALExamples_SOURCE_DIR}/../bin)

      add_executable(sealexamples examples.cpp)
      target_sources(sealexamples
          PRIVATE
              1_bfv_basics.cpp
              2_encoders.cpp
              3_levels.cpp
              4_ckks_basics.cpp
              5_rotation.cpp
              6_serialization.cpp
              7_performance.cpp
      )

      # Import Microsoft SEAL
      find_package(SEAL #{version} EXACT REQUIRED
          # Providing a path so this can be built without installing Microsoft SEAL
          PATHS ${SEALExamples_SOURCE_DIR}/../src/cmake
      )

      # Link Microsoft SEAL
      target_link_libraries(sealexamples SEAL::seal_shared)
    EOS

    system "cmake", "examples", "-DHEXL_DIR=#{lib}/cmake"
    system "make"
    # test examples 1-5 and exit
    input = "1\n2\n3\n4\n5\n0\n"
    assert_match "Correct", pipe_output("bin/sealexamples", input)
  end
end
