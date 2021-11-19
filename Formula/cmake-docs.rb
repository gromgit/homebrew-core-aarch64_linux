class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.22.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.0.tar.gz"
  sha256 "998c7ba34778d2dfdb3df8a695469e24b11e2bfa21fbe41b361a3f45e1c9345e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1612787671f3404142139acf3d989bd137ecb275db19157e907e3a0177edd5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1612787671f3404142139acf3d989bd137ecb275db19157e907e3a0177edd5e"
    sha256 cellar: :any_skip_relocation, monterey:       "01c9bf302e4de6214d93308bffde28837abe58f9f46aa0a53948add4eca632f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "01c9bf302e4de6214d93308bffde28837abe58f9f46aa0a53948add4eca632f5"
    sha256 cellar: :any_skip_relocation, catalina:       "01c9bf302e4de6214d93308bffde28837abe58f9f46aa0a53948add4eca632f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1612787671f3404142139acf3d989bd137ecb275db19157e907e3a0177edd5e"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=share/doc/cmake",
                                                             "-DCMAKE_MAN_DIR=share/man",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
