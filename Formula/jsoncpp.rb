class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.9.4.tar.gz"
  sha256 "e34a628a8142643b976c7233ef381457efad79468c67cb1ae0b83a33d7493999"
  license "MIT"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  livecheck do
    url "https://github.com/open-source-parsers/jsoncpp/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "0e937647ccad5ed68b70aa059027e367f120f7b6ad8657bfbd17ab4835a134a8" => :catalina
    sha256 "c235548c34fbf5359a780f292b20c13e17ff6a4f2de02ec5cb2116bff2b6cbf1" => :mojave
    sha256 "a31ea936169d1e199425e5125cea17ff5d61467e3825ce988a610adec0cc027b" => :high_sierra
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
