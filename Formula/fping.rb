class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-4.4.tar.gz"
  sha256 "9f854b65a52dc7b1749d6743e35d0a6268179d1a724267339fc9a066b2b72d11"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "140901f23d87023cc0234ee3ba14dfd46abaac8a0f3846c0c0a33010a74ffe1b" => :catalina
    sha256 "93d10806350b4f718d37ec248901d2b0572943501f604a0c4021af0b48117a43" => :mojave
    sha256 "d10f894fc890a3e4625b7dd603d84c407e3ec1a15902e09a6395f2df6216aa31" => :high_sierra
  end

  head do
    url "https://github.com/schweikert/fping.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_equal "::1 is alive", shell_output("#{bin}/fping -A localhost").chomp
  end
end
