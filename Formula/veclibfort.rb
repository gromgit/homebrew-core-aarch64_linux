class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.3.tar.gz"
  sha256 "fe9e7e0596bfb4aa713b2273b21e7d96c0d7a6453ee4b214a8a50050989d5586"
  license "BSL-1.0"
  head "https://github.com/mcg1969/vecLibFort.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on "gcc" # for gfortran
  depends_on :macos

  def install
    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "tester.f90"
  end

  test do
    system "gfortran", "-o", "tester", "-O", pkgshare/"tester.f90",
                       "-L#{lib}", "-lvecLibFort"
    assert_match "SLAMCH", shell_output("./tester")
  end
end
