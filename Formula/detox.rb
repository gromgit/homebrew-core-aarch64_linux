class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.4.3.tar.gz"
  sha256 "a9046976a302cb047c49439e065481d4f84811732182f40f3504fd51151edb68"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "bdc45f67f781b94e1898b7538dfed399e5d47eeeefc33eb84fe1c6cda3a469f9"
    sha256 big_sur:       "9d468f782f96d667d59892911dc1fa7ef7b40b3f0410d46c3a75147c8a5b886b"
    sha256 catalina:      "83987429b9b768b6559420dd4656603ab6c963785e87bffd02a61e2be6557393"
    sha256 mojave:        "a371814287b76ac37a6f24a719da41d5fb7d4215a2be548b075c706b1f670165"
    sha256 x86_64_linux:  "5f40b1f894af6814b279263b00f11e52c613b1ab833d0b764a9c5152aa5965b6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    pkgshare.mkpath
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
