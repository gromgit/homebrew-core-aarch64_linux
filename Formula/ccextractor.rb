class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.91.tar.gz"
  sha256 "9df507fc13777e46e97f886c76b05a36c0d26464e1e567173118295127b857ff"
  license "GPL-2.0-only"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "516389be1ca69d2ebbaa7f8694874c5df1a05fa7e91b46a669ec925e4de5c97c"
    sha256 cellar: :any,                 big_sur:       "fa4be877a0561e69a3c8b38e4b4fe3d26724cf68fb3dbf3a8df3569846c0e213"
    sha256 cellar: :any,                 catalina:      "cd523a282a74a312a62482046d0cda08dcae62b37862746fd47b5325be618d8a"
    sha256 cellar: :any,                 mojave:        "20c043838a1028d62f11bcaa63d358a90b5dbe9f6781601f86882738e1be862f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1962de3666f42c459eb1233f9e71b849c9d64a881f0652104d92677f6ad6346e"
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
