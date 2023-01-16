class Rapidjson < Formula
  desc "JSON parser/generator for C++ with SAX and DOM style APIs"
  homepage "https://rapidjson.org/"
  url "https://github.com/Tencent/rapidjson/archive/v1.1.0.tar.gz"
  sha256 "bf7ced29704a1e696fbccf2a2b4ea068e7774fa37f6d7dd4039d0787f8bed98e"
  license "MIT"
  head "https://github.com/Tencent/rapidjson.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rapidjson"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c4bdfd15863df27feafb055edfd652fc4bcf3b3609e65886e479854fb7a92e0f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  conflicts_with "mesos", because: "mesos installs a copy of rapidjson headers"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system ENV.cxx, "#{share}/doc/RapidJSON/examples/capitalize/capitalize.cpp", "-o", "capitalize"
    assert_equal '{"A":"B"}', pipe_output("./capitalize", '{"a":"b"}')
  end
end
