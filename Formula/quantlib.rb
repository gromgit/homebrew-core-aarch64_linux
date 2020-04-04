class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://dl.bintray.com/quantlib/releases/QuantLib-1.18.tar.gz"
  sha256 "d5048e14f2b7ea79f0adee08b2cbcee01b57b9cc282f60225ff4fcfc614c7ebc"

  bottle do
    cellar :any
    sha256 "1e89efdb70a7a64b10a475202070d39390fffabc0801227acf8723b6194037c4" => :catalina
    sha256 "f2bab0408cf9d6f412d6c6a9eeeab9e1ca776257eb2a6d30496bf4646eb76af3" => :mojave
    sha256 "ff0934abb2b65d970b00c7217d8563bd6757cf9cb8a02c5e9e5cec8428ecd661" => :high_sierra
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
