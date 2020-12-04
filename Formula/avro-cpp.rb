class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.1/cpp/avro-cpp-1.10.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.1/cpp/avro-cpp-1.10.1.tar.gz"
  sha256 "6e9e8820325cdaffcc1981958ed86b484c33dcf0277a164b2a58357fdd046cc8"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "1c88fc97f0773c23c2b6a8892c969f18e081d0785d28fad436d9e07535481fe7" => :big_sur
    sha256 "daf0cbf609b4fa29127875b3235e1c6e6f4da0b0eef0719b13efe5654421d7d7" => :catalina
    sha256 "42131dfe9b4c80ddd3687be2f0b2210cb45ebeb3f1189acad8af4f402b892e2c" => :mojave
    sha256 "c0b0f79d21e69a75ab3ffaf86344838082fcd6dd3927230e655ae881cd86076c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}/avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
