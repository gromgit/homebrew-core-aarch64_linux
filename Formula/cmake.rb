class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.1/cmake-3.21.1.tar.gz"
  sha256 "fac3915171d4dff25913975d712f76e69aef44bf738ba7b976793a458b4cfed4"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f1fe113553e36a528937db0888574e12ff46e4454a52c0a4cffeedfa8b4e35f"
    sha256 cellar: :any_skip_relocation, big_sur:       "811eb99b94e5359a9412a1cc4dbbcf213f3f79426fdd0983e422be67c701e1e3"
    sha256 cellar: :any_skip_relocation, catalina:      "669b2fce7ae2cfdf22283fe07f2fc73620b80690437839fb008f74cbf971be9e"
    sha256 cellar: :any_skip_relocation, mojave:        "2dd811d87869b2f48b30ef9d0270dcba483167b7c14d36dc8239e8561f0ae43f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "742da457c9b45d0580d8e00e9638cedcfe18d1a82c57cb80d035e707062e1d68"
  end

  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

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
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"

    # Remove deprecated and unusable binary
    # https://gitlab.kitware.com/cmake/cmake/-/issues/20235
    (pkgshare/"Modules/Internal/CPack/CPack.OSXScriptLauncher.in").unlink
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
