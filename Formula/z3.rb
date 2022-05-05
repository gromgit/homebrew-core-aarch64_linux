class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.17.tar.gz"
  sha256 "1e57637ce8d5212fd38453df28e2730a18e0a633f723682267be87f5b858a126"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "82ac6d2c5d65395f06050732f71729a09164fcb7bfc2cf9b2e037aa640f2f3d6"
    sha256 cellar: :any,                 arm64_big_sur:  "a6274d2eea099f27c19bfbd736f4909ee9a373124ef0c017954fd38d56f4061c"
    sha256 cellar: :any,                 monterey:       "45f94dbf9ed1ee4434d2c630856bcffc0c32e0f59ee5d2538ade1343e14c139b"
    sha256 cellar: :any,                 big_sur:        "0b7a13c06b7868fead0627ab72aafc7df8317a1dff775a800e890d43b956eb21"
    sha256 cellar: :any,                 catalina:       "f7b34ccf850fcdb189f6ee3cfbaeca240247e18ae5fdaa8fa722f5113a5e43d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a51d922fdc77664c58b5aab226b2adbb4f7b44cda2ca70ba537b096af2dff7"
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    python3 = Formula["python@3.10"].opt_bin/"python3"
    system python3, "scripts/mk_make.py",
                     "--prefix=#{prefix}",
                     "--python",
                     "--pypkgdir=#{prefix/Language::Python.site_packages(python3)}",
                     "--staticlib"

    cd "build" do
      system "make"
      system "make", "install"
    end

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
