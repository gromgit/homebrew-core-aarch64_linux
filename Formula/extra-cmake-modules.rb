class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.84/extra-cmake-modules-5.84.0.tar.xz"
  sha256 "bb085ef2e177c182ff46988516b6b31849d1497beb2ff5301165ad2ba12a1c41"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56bdc1b38e066d1443f53f2f9a78af230d790120ccee758ed453d279e3021b7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "2fa171d121811d54b803415a8f12c8c98e3b28dc1ccd7a3be9cf0cfdbac44e2a"
    sha256 cellar: :any_skip_relocation, catalina:      "2fa171d121811d54b803415a8f12c8c98e3b28dc1ccd7a3be9cf0cfdbac44e2a"
    sha256 cellar: :any_skip_relocation, mojave:        "04bc190698d581b22b41ca6825f5c26dfce1fdf78de4d29e05859e3643f8de06"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :build
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
