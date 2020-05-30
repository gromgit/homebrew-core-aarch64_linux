class Widelands < Formula
  desc "Free real-time strategy game like Settlers II"
  homepage "https://www.widelands.org/"
  url "https://launchpad.net/widelands/build20/build20/+download/widelands-build20.tar.bz2"
  sha256 "38594d98c74f357d4c31dd8ee2b056bfe921f42935935af915d11b792677bcb2"
  revision 4

  bottle do
    sha256 "2cb0df8e7a793af4af1c1219e71a0391ce3151e5758a4692a2bdca4ef50e8f54" => :catalina
    sha256 "f4ccff038d304f9b45e08c513e31f8334426db02afee8a316e069a0324f61314" => :mojave
    sha256 "cc98eb5769c9c7c24cc742d821d6d54e643880a078ce736f606eccd1cceb2344" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "doxygen"
  depends_on "gettext"
  depends_on "glew"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "minizip"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..",
                      # Without the following option, Cmake intend to use the library of MONO framework.
                      "-DPNG_PNG_INCLUDE_DIR:PATH=#{Formula["libpng"].opt_include}",
                      "-DWL_INSTALL_DATADIR=#{pkgshare}/data",
                       *std_cmake_args
      system "make", "install"

      (bin/"widelands").write <<~EOS
        #!/bin/sh
        exec #{prefix}/widelands "$@"
      EOS
    end
  end

  test do
    system bin/"widelands", "--version"
  end
end
