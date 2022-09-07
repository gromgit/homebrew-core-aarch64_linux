class Zzz < Formula
  desc "Command-line tool to put Macs to sleep"
  homepage "https://github.com/Orc/Zzz"
  url "https://github.com/Orc/Zzz/archive/v1.tar.gz"
  sha256 "8c8958b65a74ab1081ce1a950af6d360166828bdb383d71cc8fe37ddb1702576"
  head "https://github.com/Orc/Zzz.git", branch: "main"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  # No test is possible: this has no --help or --version, it just
  # sleeps the Mac instantly.
  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_predicate bin/"Zzz", :exist?
  end
end
