class Wxwidgets < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.0/wxWidgets-3.2.0.tar.bz2"
  sha256 "356e9b55f1ae3d58ae1fed61478e9b754d46b820913e3bfbc971c50377c1903a"
  license "wxWindows"
  revision 1
  head "https://github.com/wxWidgets/wxWidgets.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f82e5102e00d063b2147b4fd19671dc54933038cd0f6036eeeaad462856a00da"
    sha256 cellar: :any,                 arm64_big_sur:  "d22754feb51491069e60d590292fa4e52663030c950ef930eb179706bedec72d"
    sha256 cellar: :any,                 monterey:       "378d100c3066938cfd47f2b33508dc72061b57aba8bebcdff2e2c1884b72ba6d"
    sha256 cellar: :any,                 big_sur:        "54f03e7ef16ced680b6e8eeccc5fd077669af9ab8d1e020c165274f036bc94cb"
    sha256 cellar: :any,                 catalina:       "8fa5b3a5b42f734c036d2b5d6750513a9ad71a9b2dc6729fe39a1e14140b9688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ed6f286f589cfdba01bb3e39296b4c7a51197834cd3307399e98555292f6f8"
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
    depends_on "libsm"
    depends_on "mesa-glu"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webviewwebkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
    ]

    if OS.mac?
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      args << "--with-macosx-version-min=#{MacOS.version}"
      args << "--with-osx_cocoa"
      args << "--with-libiconv"
    end

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxwidgets's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxwidgets and wxpython headers,
    # which are linked to the same place
    inreplace bin/"wx-config", prefix, HOMEBREW_PREFIX

    # For consistency with the versioned wxwidgets formulae
    bin.install_symlink bin/"wx-config" => "wx-config-#{version.major_minor}"
    (share/"wx"/version.major_minor).install share/"aclocal", share/"bakefile"
  end

  test do
    system bin/"wx-config", "--libs"
  end
end
