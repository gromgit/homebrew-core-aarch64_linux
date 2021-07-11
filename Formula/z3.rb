class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.11.tar.gz"
  sha256 "99e912b9af76a17f8827f89afcf4da117736f3877a8bbdd737c548c6541009d7"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f4df8ed264a23bb2c2e1c9fd5560fe30ceb6766acd2d479d93b779c7a3a26457"
    sha256 cellar: :any, big_sur:       "1a35e6875fdfe301806cec2ce15cff8f28d81c34c4bcd5887d3fa00a3e61cf3d"
    sha256 cellar: :any, catalina:      "0b1664a576a55439cff74a620e12f854fc798d9b911594226dfc8f3d07604adc"
    sha256 cellar: :any, mojave:        "9cd9c59be9836e57ac80431b20c239f61205e696ad8bd11835b6203996463671"
  end

  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.9" => :build

  def install
    python3 = Formula["python@3.9"].opt_bin/"python3"
    xy = Language::Python.major_minor_version python3
    system python3, "scripts/mk_make.py",
                     "--prefix=#{prefix}",
                     "--python",
                     "--pypkgdir=#{lib}/python#{xy}/site-packages",
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
