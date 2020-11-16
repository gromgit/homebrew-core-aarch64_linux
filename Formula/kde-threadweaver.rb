class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.76/threadweaver-5.76.0.tar.xz"
  sha256 "8bc0cc4507b4cd7398e18cce8519b4a65b0367e7d22c4faae034a57346297039"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 "59ee0d9d4dc2b7c4c71610e7001156fdaa3624414deffb886ba5b792763a9d84" => :big_sur
    sha256 "164bff29c9e86b18b220114474a161dc357520a94c5f73a7c8eda3a41bfe7ad0" => :catalina
    sha256 "1b65feef29deba278b42626da108ed6e838641e4c731d569af0352f748e76434" => :mojave
    sha256 "51f6b317bc405e6b1aa04636a5d80b1d0992963176e86a6f0ad8796467aa7400" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    qt5_arg = "-DQt5Core_DIR=#{Formula["qt"].opt_prefix/"lib/cmake/Qt5Core"}"
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, qt5_arg
    system "make"

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
