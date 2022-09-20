class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/minetest/minetest/archive/5.6.1.tar.gz"
    sha256 "1440603e19dca70e2691e86a74c822ee2c4a36fceee32b2d85ae74772149e9a3"

    resource "irrlichtmt" do
      url "https://github.com/minetest/irrlicht/archive/refs/tags/1.9.0mt8.tar.gz"
      sha256 "27594242da8c7cc1e5ef45922e1dfdd130c37d77719b5d927359eb47992051e0"
    end

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/refs/tags/5.6.1.tar.gz"
      sha256 "5dc857003d24bb489f126865fcd6bf0d9c0cb146ca4c1c733570699d15abd0e3"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "db61d1bb750b5c89687b656a1c4ef53ae705b61b0aa754acc6a122ff2e243e88"
    sha256 cellar: :any, arm64_big_sur:  "62bbcf421730080a0ec2b042218c5b462243fb66ca7b0b4d1ba049add35131bc"
    sha256 cellar: :any, monterey:       "c995894c0f9fc6be6969d937e84df909481ae337cd67856f554782be96f3e39f"
    sha256 cellar: :any, big_sur:        "9872201a11cb698640176786b0d279f18e4ece426553036f0f768142471892b6"
    sha256 cellar: :any, catalina:       "9bd8ddcd6f601c03e353e41b09efc0850bbef88843d208f8ebf8e5d4ad98b75c"
    sha256               x86_64_linux:   "6f28d73bbec90086c06f8bb2f0870738e51fd50666ee80c06452a27199921caf"
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
