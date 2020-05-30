class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.19.tar.gz"
  sha256 "db21584c5b557af622e6fc45e97e80ae579a0e33805ffb123dea2ddaf36b4dae"
  revision 1

  bottle do
    cellar :any
    sha256 "94c22335f86fea50f5ad13b67725ba29934e9aaef3346295e96256a51c1eec11" => :catalina
    sha256 "c547cce46e8b07b758d535d3d9a8280ab7720234561ac4550b53eaf85cd7ce91" => :mojave
    sha256 "65fb65eb0498fe59c5a05ea1305b950903d90b8f8c52e5bec555a2c4f0ad89e8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    args = [
      "--lto-thin",
      "--icu=#{Formula["icu4c"].opt_include}",
      "--extra-defines=U_USING_ICU_NAMESPACE=1", # icu4c 61.1 compatability
      "-j=#{ENV.make_jobs}",
      "-y",
    ]

    # Build dynamically for the shared library
    system "./build.sh", *args
    # Then statically to get a usable binary
    system "./build.sh", "--static", *args

    bin.install "out/Release/ch" => "chakra"
    include.install Dir["out/Release/include/*"]
    lib.install "out/Release/libChakraCore.dylib"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
