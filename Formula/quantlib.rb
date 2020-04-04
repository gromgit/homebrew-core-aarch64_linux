class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.18.tar.gz"
  sha256 "d5048e14f2b7ea79f0adee08b2cbcee01b57b9cc282f60225ff4fcfc614c7ebc"

  bottle do
    cellar :any
    sha256 "ced07254983567737434dfbd09cbdf9d50bee955a2a6c29d08a8c8d760cae229" => :catalina
    sha256 "dcd3d6b1148eb321fdd0a4b85f1b7ec595004df4239d8acc18a6636d57149665" => :mojave
    sha256 "582ec936bf29501cbaaef0d07020247e890ccc8590a442a85d5d90fb7f61c372" => :high_sierra
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
