class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.1/c/avro-c-1.10.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.1/c/avro-c-1.10.1.tar.gz"
  sha256 "5313dcb6d240b919f218a80a8b9b58f7a3eb501ff177b0dedc1c0595d0ee916d"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "7abc536f295117964af2d32b3d16a48482109653a71a55614b9f0f4a0a4ec7a9" => :big_sur
    sha256 "44708472b87d7d9375ed156ad510f1884b050d4cc345bfef49e6e9f2bc7a756c" => :catalina
    sha256 "971102fc6b294cb8b98759edba3e390d376d7660eb49c6ed9063e03cf0cf2067" => :mojave
    sha256 "6aec75d7260ab6eb56a7c7b6bceb03f547947a2b1c0eba579ad21a7b048b0367" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "tests/test_avro_1087"
  end

  test do
    assert shell_output("#{pkgshare}/test_avro_1087")
  end
end
