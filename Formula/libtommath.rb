class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.2.0/ltm-1.2.0.tar.xz"
  sha256 "b7c75eecf680219484055fcedd686064409254ae44bc31a96c5032843c0e18b1"
  license "Unlicense"
  revision 3
  head "https://github.com/libtom/libtommath.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libtommath"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "37e6fcf9d4d83f1b7bc06d379076d8e7c40f4c083c898e8782dea9052386a111"
  end

  depends_on "libtool" => :build

  # Fixes mp_set_double being missing on macOS.
  # This is needed by some dependents in homebrew-core.
  # NOTE: This patch has been merged upstream but we take a backport
  # from a fork due to file name differences between 1.2.0 and master.
  # Remove with the next version.
  patch do
    url "https://github.com/MoarVM/libtommath/commit/db0d387b808d557bd408a6a253c5bf3a688ef274.patch?full_index=1"
    sha256 "e5eef1762dd3e92125e36034afa72552d77f066eaa19a0fd03cd4f1a656f9ab0"
  end

  def install
    ENV["PREFIX"] = prefix

    system "make", "-f", "makefile.shared", "install"
    system "make", "test"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
