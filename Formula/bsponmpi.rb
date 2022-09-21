class Bsponmpi < Formula
  desc "Implements the BSPlib standard on top of MPI"
  homepage "https://sourceforge.net/projects/bsponmpi/"
  url "https://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz"
  sha256 "bc90ca22155be9ff65aca4e964d8cd0bef5f0facef0a42bc1db8b9f822c92a90"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  # SConstruct is written in Python 2 but Homebrew `scons` is built for Python 3
  deprecate! date: "2021-08-08", because: :does_not_build

  depends_on "scons" => :build
  depends_on :macos
  depends_on "open-mpi"

  def install
    # Don't install 'CVS' folders from tarball
    rm_rf "include/CVS"
    rm_rf "include/tools/CVS"
    system "scons", "-Q", "mode=release"
    prefix.install "lib", "include"
  end
end
