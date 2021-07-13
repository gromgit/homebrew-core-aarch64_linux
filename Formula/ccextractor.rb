class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.89.tar.gz"
  sha256 "bbe8d95347d0cf31bd26489b733fd959a7b98c681f14c59309bff54713fd539d"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a7e9e2088a8fa3602c973e2813974815459efb7cc9a1fd9c73c750e237eeae9b"
    sha256 cellar: :any, big_sur:       "1d4cd6930431fd7ce56192bb53bb46d14a01867ecdafc1cb37f6e8dbda373e2e"
    sha256 cellar: :any, catalina:      "110a63c1f4a0ac8749418f2158aa15c4e3bbace5ee4820506d4c7b4e489e9a30"
    sha256 cellar: :any, mojave:        "0c3e69d834f8e4abfcab5f5c0069534707634ebae7d4bc356c8ac10207358762"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gpac"
  depends_on "leptonica"
  depends_on "libpng"
  depends_on "protobuf-c"
  depends_on "tesseract"
  depends_on "utf8proc"

  resource "test.mxf" do
    url "https://raw.githubusercontent.com/alebcay/example-artifacts/5e8d84effab76c4653972ef72513fcee1d00d3c3/mxf/test.mxf"
    sha256 "e027aca08a2cce64a9fb6623a85306b5481a2f1c3f97a06fd5d3d1b45192b12a"
  end

  # Patch build script to allow building with Homebrew libs rather than upstream's bundled libs
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9bc4ef5a88b9a4d55dead30130aa79f8eee5faf7/ccextractor/unbundle-libs.patch"
    sha256 "b610950e4ae54a8fce3f5952be6d909cb9790a9c46ff356f83e8d8255c7f1ed1"
  end

  def install
    # Multiple source files reference these dependencies with non-standard #include paths
    ENV["EXTRA_INCLUDE"] = "-I#{Formula["leptonica"].include} -I#{Formula["protobuf-c"].include/"protobuf-c"}"

    platform = "mac"
    build_script = "./build.command"

    on_linux do
      platform = "linux"
      build_script = "./build"
    end

    cd platform do
      system build_script, "OCR"
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    resource("test.mxf").stage do
      system bin/"ccextractor", "test.mxf", "-out=txt"
      assert_equal "This is a test video.", (Pathname.pwd/"test.txt").read.strip
    end
  end
end
