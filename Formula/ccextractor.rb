class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.89.tar.gz"
  sha256 "bbe8d95347d0cf31bd26489b733fd959a7b98c681f14c59309bff54713fd539d"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "85a8a4d0137ec1f12e98ad39156d1ee95874b037d432c9620d65f695dcbb3daa"
    sha256 cellar: :any_skip_relocation, catalina: "22e12e434b2a59c0ee63db41e876add7ab686d7e015c7319bf3cecd01ae2de1e"
    sha256 cellar: :any_skip_relocation, mojave:   "f389af83990016793f29329e7de8ca7d58c09a25c7faff62bc61d0100d9ee425"
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
