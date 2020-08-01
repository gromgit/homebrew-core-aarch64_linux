class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxwidgets.org/"
  url "https://files.pythonhosted.org/packages/cb/4f/1e21d3c079c973ba862a18f3be73c2bbe2e6bc25c96d94df605b5cbb494d/wxPython-4.1.0.tar.gz"
  sha256 "2e2475cb755ac8d93d2f9335c39c060b4d17ecb5d4e0e86626d1e2834b64a48b"

  bottle do
    cellar :any
    sha256 "7e3a70eb66502508bbcad970815aea6373012c0aa9ef632d12d20127cefba693" => :catalina
    sha256 "77a519db391a01f82c11b6a887671d610c58f579eb676bfcbd013afd644cc6fc" => :mojave
    sha256 "6b9ab4453cc2db1490b13c8449519fa9e067ffdeaed843603ad9dc9d87ff3db2" => :high_sierra
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "python@3.8"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/3e/02/b09732ca4b14405ff159c470a612979acfc6e8645dc32f83ea0129709f7a/Pillow-7.2.0.tar.gz"
    sha256 "97f9e7953a77d5a70f49b9a48da7776dc51e9b738151b22dacf101641594a626"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    # Fix build of included wxwidgets:
    # https://github.com/wxWidgets/Phoenix/issues/1247
    # https://github.com/Homebrew/homebrew-core/pull/58988
    inreplace "buildtools/build_wxwidgets.py" do |s|
      s.gsub! "#wxpy_configure_opts.append(\"--enable-monolithic\")",
              "wxpy_configure_opts.append(\"--disable-precomp-headers\")"
      s.gsub! "--with-macosx-version-min=10.9",
              "--with-macosx-version-min=#{MacOS.version}"
    end

    inreplace "wscript", "MACOSX_DEPLOYMENT_TARGET = \"10.6\"",
                         "MACOSX_DEPLOYMENT_TARGET = \"#{MacOS.version}\""

    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "xcb.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None",
          "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None",
          "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None",
          "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      unless MacOS::CLT.installed?
        ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["Pillow"]
    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    output = shell_output("#{Formula["python@3.8"].opt_bin}/python3 -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
