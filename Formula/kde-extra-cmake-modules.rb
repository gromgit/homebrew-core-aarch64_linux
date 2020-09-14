class KdeExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.74/extra-cmake-modules-5.74.0.tar.xz"
  sha256 "71406067bcd99ac106e0e3bfbb073653b18fd6d01039c0298d9767680977364f"
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d4d8ba9eb87ab1469ad89fba8b36c52fbc6dbf5708d965bb1d8bbb7f9ff36221" => :catalina
    sha256 "efebab28b28b19d32c52d19260a4b336c08cccf9d1ea7b7bfdd44371329a8055" => :mojave
    sha256 "9d3a79667fde10f785d04c9143ead052c454a7930ca08e003299f7ecbc576fb4" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_HTML_DOCS=ON"
    args << "-DBUILD_MAN_DOCS=ON"
    args << "-DBUILD_QTHELP_DOCS=ON"
    args << "-DBUILD_TESTING=OFF"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(ECM REQUIRED)")
    system "cmake", ".", "-Wno-dev"

    expected="ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, File.read(testpath/"CMakeCache.txt")
  end
end
