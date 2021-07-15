class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.90.tar.gz"
  sha256 "288976bebbb790920be7bb9a7e5809806936bd607eafbfba7d5385b7624cbdc7"
  license "GPL-2.0-only"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "794664ba25d43abea2ead15bf379988b33c9918d87b1820c9d5299f2eb578872"
    sha256 cellar: :any,                 big_sur:       "84a352a7c904d125432561fbc523af6c2f153325d1f22d04b44e24cf2cbc1e7b"
    sha256 cellar: :any,                 catalina:      "58f33906afe14cb88aec95869d89fcee05143ee8f950c97059d773480cbfd259"
    sha256 cellar: :any,                 mojave:        "0aa79c982682e554bac26e7c31d9940fcca61862025834f197192eb4ff3ffcce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3363adaa15422924d2fdf1c88ea3d553cff1d9cf487bcad4767128ed587ff2"
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
