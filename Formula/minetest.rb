class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/minetest/minetest/archive/5.6.0.tar.gz"
    sha256 "3fdbc0c8d9f6a18c12954ba0caedb548a22f367520f59d079804a21de0347a91"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht/archive/1.9.0mt7.tar.gz"
      sha256 "c12cdbd4a852e1e6ebf7ba22789aa057a1a7f2d585dd81a2412a62f57a0e2619"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.6.0.tar.gz"
      sha256 "fd991d42c253db380559c593a2b035f22e07a81f867b5380a2f045e9a4d04c87"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "fe56419d18e25c0f7b0d198d0f1d44ee1e418b18bcbe34b458b181747fa0793d"
    sha256 cellar: :any, arm64_big_sur:  "4609f23fc7e9c1ed432645cb87f0279c5c1ec33039ee1b397c7107bc77def44b"
    sha256 cellar: :any, monterey:       "d922d848edf2c1547891ee81034537867bb9c6847322faeb52ab6a6598acc426"
    sha256 cellar: :any, big_sur:        "98495a6cc6b22b5ab3c83a89b1a5d03398f838dc09fcff114b1d135cec5e419b"
    sha256 cellar: :any, catalina:       "408d8a9b6b98e59dd1b4a2ea026f3af15a65d538f9f02a0d57f1fe45238ece25"
    sha256               x86_64_linux:   "7f71477eee5745c98fc7236d65aded9fb830b3b1be1b7d85a793bd951062c721"
  end

  head do
    url "https://github.com/minetest/minetest.git", branch: "master"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht.git", branch: "master"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "freetype"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "openal-soft"
    depends_on "xinput"
  end

  def install
    inreplace "src/CMakeLists.txt" do |s|
      # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
      # On Apple ARM, the flags results in broken binaries and need to be removed.
      s.gsub! " -pagezero_size 10000 -image_base 100000000\"", "\""
      # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
      s.gsub! "fixup_bundle(", "# \\0"
    end

    # Remove bundled libraries to prevent fallback
    %w[lua gmp jsoncpp].each { |lib| (buildpath/"lib"/lib).rmtree }

    (buildpath/"games/minetest_game").install resource("minetest_game")
    (buildpath/"lib/irrlichtmt").install resource("irrlichtmt")

    args = %W[
      -DBUILD_CLIENT=1
      -DBUILD_SERVER=0
      -DENABLE_FREETYPE=1
      -DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'
      -DENABLE_GETTEXT=1
      -DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}
    ]
    # Workaround for 'Could NOT find GettextLib (missing: ICONV_LIBRARY)'
    args << "-DICONV_LIBRARY=#{MacOS.sdk_path}/usr/lib/libiconv.tbd" if MacOS.version >= :big_sur

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script prefix/"minetest.app/Contents/MacOS/minetest" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/minetest --version")
    assert_match "USE_CURL=1", output
    assert_match "USE_GETTEXT=1", output
    assert_match "USE_SOUND=1", output
  end
end
