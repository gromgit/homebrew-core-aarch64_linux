class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.10.2.tar.gz"
  sha256 "889fd035b833775c8cd2eb4723eb011bf916a3e9bf08ce66b31c548acee7a321"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5832415228ecb5210fbc59c2a7acb0be6d2c1d772948c06a7be494ad5f84c27f"
    sha256 cellar: :any,                 arm64_big_sur:  "eba2eaab87ee27f45715bc72ed5a5ab4583844129746d4d543ce795483bd0da8"
    sha256 cellar: :any,                 monterey:       "ce0b33685e14641d7b83fed58a8ffb0bcca31db1dd06b2c80d450aa3b567f87a"
    sha256 cellar: :any,                 big_sur:        "9cafa3bfbbed84b2fcdfc0cb13dbe0887d2f0b6552b36d88834abf3f776ff990"
    sha256 cellar: :any,                 catalina:       "90b4e797bc39d8d1d80c17977bf20d4db556e8f6ba72b2a0917bc3e50c858e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d02ea987e8af7ab510c201ef759994bc737ff84a6aed372c63cc03b0280fd905"
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
