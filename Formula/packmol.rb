class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/v20.11.0.tar.gz"
  sha256 "0ca999875487cd15ea575c82a590333c7ff63b2d2b42448645acd650e6821398"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9b0671562d5d5c490af41b77af3e4e62708883a2a2f9aa465fd42df7471c85a"
    sha256 cellar: :any,                 arm64_monterey: "4f1afb57de63afe102cedf900ae3e6fd7d3ed6eaee7d4221f6c1c9453813b931"
    sha256 cellar: :any,                 arm64_big_sur:  "3adfa0f57afadf605e10d6ffbad8270683fa2a289bffcb56d4d5389af76a1fe9"
    sha256                               ventura:        "299ed04aa9c3fa0f9f315c11bf6f9a2efb56bab618c2386096cb516880014938"
    sha256                               monterey:       "b8456629364d20ecd067449dbcd38dde85f5fe09069129c71602f07ec1097c0d"
    sha256                               big_sur:        "8a31e699d23377960bf668e5c715f6ee13b7514a287e7bfed3ecb81aa7223078"
    sha256                               catalina:       "f3320c503509b9fe783c5953ef0dd25818ee13d310beafdb9bf048b126d450c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c62ae6f6b423fc5a4da7ef21251afb5230511800540c69aa187926dbdf89c44e"
  end

  depends_on "gcc" # for gfortran

  resource "examples" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    # upstream PR ref, https://github.com/m3g/packmol/pull/39
    inreplace "Makefile", ": strlength.f90", ": strlength.f90  $(modules)"

    system "./configure"
    system "make"
    bin.install("packmol")
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("examples")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
