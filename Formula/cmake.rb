class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.18.1/cmake-3.18.1.tar.gz"
  sha256 "c0e3338bd37e67155b9d1e9526fec326b5c541f74857771b7ffed0c46ad62508"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4822a39fbbb0e3b3c134bf7e09c89fec8da3ebd0de371de705cc62f4051d865a" => :catalina
    sha256 "99f3b99f0bdd3dfd06b4ef1b9fbf9fd4cdffdd30ee52add434f80988075d1f0d" => :mojave
    sha256 "168e2838e13a799b2a42642e8976f73c5daeaa16031dd8fedd724d384c7bdb54" => :high_sierra
  end

  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
