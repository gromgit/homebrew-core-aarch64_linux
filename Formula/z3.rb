class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.11.2.tar.gz"
  sha256 "e3a82431b95412408a9c994466fad7252135c8ed3f719c986cd75c8c5f234c7e"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/z3[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "746d3acac5a934976d144d4a30d94c2255828b834552f794bee939adb63bbb00"
    sha256 cellar: :any,                 arm64_big_sur:  "10045c9e7413b6ce2cd09a6e63f5183e3a78f5d02230c269bea1d0600e65d6f9"
    sha256 cellar: :any,                 monterey:       "7fcd99bc44de11062be64aac91c3cf04e4a78f5de2a78f20515e0e5f8e1c0947"
    sha256 cellar: :any,                 big_sur:        "5c2d9ab8910e37cc6730b65c283cfc59a37235d1cbaf1be08a2bc7b56fb72fba"
    sha256 cellar: :any,                 catalina:       "dcf0a7547b52b1fc17e6a09e77927f5dfa618c0b95843fafa63add00ca10f1b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1092855bd8322aaa81aa1d194c70c4ff3227b9038846fbc7096f99d5d3f52606"
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
