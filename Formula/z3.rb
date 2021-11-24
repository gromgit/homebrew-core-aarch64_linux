class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.13.tar.gz"
  sha256 "59a0b35711fa7ae48dd535116d2067a6a16955fcbf2623c516a3f630cd2832d8"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "564b46fb88f41f2e440bb554d36d984ee615cd1cf92d5aba6aa6f49f73e30e94"
    sha256 cellar: :any,                 arm64_big_sur:  "76d0c80cbd9977f713ac7765db062360e2601fec1d4a0b9207524c6f3470b4e2"
    sha256 cellar: :any,                 monterey:       "a87f32a7afb7a9b08e6afcf07990cd1a1665e702676b41fea9ce7b43aaa57916"
    sha256 cellar: :any,                 big_sur:        "1841839337cccb96e3c8dfac3ab975d8957ccc877fe2276520955d52a4523e36"
    sha256 cellar: :any,                 catalina:       "7839421e5c7539dbab69e3610d542adf70d7346b0eadbec9dbd36b539962c837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1d096669fdb622d1fa03c5654a2a10966a98732d76a092d4bb9040bb8503d9"
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
