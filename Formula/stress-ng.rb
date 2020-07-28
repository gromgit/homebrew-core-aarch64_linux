class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.17.tar.xz"
  sha256 "860291dd3a18b985b3483190a627bbede2b5c52113766c1921001b3fb4b83af0"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "01fef2c66d2c1cbd73ba197a1b3156d708c6ae0138b058f350c16fe3a66e6f4d" => :catalina
    sha256 "9a08087727f24c7d11c11b154dd6194d663dd49262047ce24ec8d7433bd17cbf" => :mojave
    sha256 "2beb7847394f25cd382da5ede362eaa50d961c1534c25cded2ce07e7ab25ba7c" => :high_sierra
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
