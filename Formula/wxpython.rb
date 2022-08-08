class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/b0/4d/80d65c37ee60a479d338d27a2895fb15bbba27a3e6bb5b6d72bb28246e99/wxPython-4.1.1.tar.gz"
  sha256 "00e5e3180ac7f2852f342ad341d57c44e7e4326de0b550b9a5c4a8361b6c3528"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 3

  bottle do
    sha256 cellar: :any, arm64_monterey: "7b558516617be5aa563cf1250276eea3eda660e19bdf8bf66417aa55215992ea"
    sha256 cellar: :any, arm64_big_sur:  "89af5734fee0d433fff77e1cb39f4beaea35fc17518ca0dc99881c892518f0b4"
    sha256 cellar: :any, monterey:       "25ed4d082bf30adc0cdd9652f1866702345ae422d69329e0e3a683522d5a5d9d"
    sha256 cellar: :any, big_sur:        "cf40f9fb59df2b8ea5712b1bf4e1891694c144a010a7b119a6df24f39b46c8a3"
    sha256 cellar: :any, catalina:       "363cff6b220e1d12e1075e3dfbb580eab83c0fea65f3c4f398d2d6eba80c5145"
  end

  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "pillow"
  # The current stable release 4.1.1 is incompatible with Python 3.10.
  # Requires backporting multiple upstream commits (e.g. PR 2026, 2039, 2062, ...)
  # TODO: Update to `python@3.10` on next release.
  # Ref: https://src.fedoraproject.org/rpms/python-wxpython4/commits/
  depends_on "python@3.9"
  depends_on "six"
  depends_on "tcl-tk"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  def install
    # Work around error: [Errno 2] No such file or directory: 'brew'
    # Try removing in the next release.
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Fix build of included wxwidgets:
    # https://github.com/wxWidgets/Phoenix/issues/1247
    # https://github.com/Homebrew/homebrew-core/pull/58988
    inreplace "buildtools/build_wxwidgets.py" do |s|
      s.gsub! "#wxpy_configure_opts.append(\"--enable-monolithic\")",
              "wxpy_configure_opts.append(\"--disable-precomp-headers\")"
    end

    inreplace "wscript", "MACOSX_DEPLOYMENT_TARGET = \"10.6\"",
                         "MACOSX_DEPLOYMENT_TARGET = \"#{MacOS.version}\""

    if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      ENV.append_to_cflags "-I#{sdk}/usr/include"
    end
    system "python3.9", *Language::Python.setup_install_args(prefix)
  end

  test do
    output = shell_output("python3.9 -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
