class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/v1.9.3.tar.gz"
  sha256 "8593c1d69e703563d94d8c12244e2e18893eeb9a8a9f8aa3d09a327aa45c8f7d"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "72ccd05545ec772fe1c0fb52e61f899e803b10e8a3cc8d5ae81d17c21d7685af" => :catalina
    sha256 "a3ea2b6e4e3e9b85565b473c1dd8826611a54d58d896c7d183b531f45f1d69e4" => :mojave
    sha256 "6845ead23ea19d336483799227e497eb7b1e45c0e67b91cd85b424a842a8b188" => :high_sierra
    sha256 "5b4f345172c39853765b57eb0c7a706454031cf3a6da1c00a2b3d61244b20ada" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.8" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dpython=#{Formula["python@3.8"].opt_bin}/python3", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <json/json.h>
      int main() {
          Json::Value root;
          Json::CharReaderBuilder builder;
          std::string errs;
          std::istringstream stream1;
          stream1.str("[1, 2, 3]");
          return Json::parseFromStream(builder, stream1, &root, &errs) ? 0: 1;
      }
    EOS
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test",
                  "-I#{include}/jsoncpp",
                  "-L#{lib}",
                  "-ljsoncpp"
    system "./test"
  end
end
