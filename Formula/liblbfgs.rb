class Liblbfgs < Formula
  desc "C library for limited-memory BFGS optimization algorithm"
  homepage "https://www.chokkan.org/software/liblbfgs"
  url "https://github.com/chokkan/liblbfgs/archive/refs/tags/v1.10.tar.gz"
  sha256 "95c1997e6c215c58738f5f723ca225d64c8070056081a23d636160ff2169bd2f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/liblbfgs"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8fadbb9bd3f1206199918f2fed1d9ae0101f808c0337ebd16dfbcdfa4a46c0df"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
    pkgshare.install "sample/sample.c"
  end

  test do
    cp pkgshare/"sample.c", testpath/"sample.c"
    system ENV.cc, "sample.c", "-I#{include}", "-L#{lib}", "-llbfgs", "-o", "./test"
    output = shell_output("./test")

    assert_match "L-BFGS optimization terminated with status code = 0", output
    assert_match "fx = 0.000000, x[0] = 1.000000, x[1] = 1.000000", output
  end
end
