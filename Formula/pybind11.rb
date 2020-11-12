class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.6.1.tar.gz"
  sha256 "cdbe326d357f18b83d10322ba202d69f11b2f49e2d87ade0dc2be0c5c34f8e2a"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "f82ee7efa7a670854e9729565bebf4e24414e236edefcf29e1105918dfe1068b" => :catalina
    sha256 "e541288f83294786c80bc2aacac0897f5c7dc033908472e188e3520d5036408a" => :mojave
    sha256 "714349f104f6dd2cbba662277d4d3702fcadc141bb4592eae1a9fb0dfc223d31" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :test

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DPYBIND11_TEST=OFF",
           "-DPYBIND11_NOPYTHON=ON",
           *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_MODULE(example, m) {
          m.doc() = "pybind11 example plugin";
          m.def("add", &add, "A function which adds two numbers");
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    python_flags = `#{Formula["python@3.9"].opt_bin}/python3-config --cflags --ldflags --embed`.split(" ")
    system ENV.cxx, "-O3", "-shared", "-std=c++11", *python_flags, "example.cpp", "-o", "example.so"
    system Formula["python@3.9"].opt_bin/"python3", "example.py"
  end
end
