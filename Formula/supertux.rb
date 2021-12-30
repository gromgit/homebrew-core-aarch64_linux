class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.6.3/SuperTux-v0.6.3-Source.tar.gz"
  sha256 "f7940e6009c40226eb34ebab8ffb0e3a894892d891a07b35d0e5762dd41c79f6"
  license "GPL-3.0-or-later"
  head "https://github.com/SuperTux/supertux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c43cf071cc0f131af3b0e21d82eb18ef691e23905b8bd0a851218d1221a7221d"
    sha256 cellar: :any, arm64_big_sur:  "a43aa28db1ce468178567d76e8d62ecc90b7059efebf09e7486adeb7fb4fa22e"
    sha256 cellar: :any, monterey:       "416ca52bb2f3184cb76c3afd0d56429fb204f9d627d013f19c922b6418b712e5"
    sha256 cellar: :any, big_sur:        "b2a5292147a6d0f84589d699a2c5f0ffb196602640c5302f82281d021274c506"
    sha256 cellar: :any, catalina:       "59c8ea513385b6d4785c28cca54864ebdcc415d5ece4fe724d11a4a74f7f95cc"
    sha256 cellar: :any, mojave:         "2b0b76de7aa2d930df7d8b22eb3389c4dcaea132a45de9eb88907ded500c7cb3"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openal-soft"
  end

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=share/supertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary files
    (share/"applications").rmtree
    (share/"pixmaps").rmtree
    (prefix/"MacOS").rmtree if OS.mac?
  end

  test do
    (testpath/"config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --userdir #{testpath} --version").chomp
  end
end
