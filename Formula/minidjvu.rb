class Minidjvu < Formula
  desc "DjVu multipage encoder, single page encoder/decoder"
  homepage "http://minidjvu.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/minidjvu/minidjvu/0.8/minidjvu-0.8.tar.gz"
  sha256 "e9c892e0272ee4e560eaa2dbd16b40719b9797a1fa2749efeb6622f388dfb74a"

  bottle do
    sha256 "7a111b89510411f32b36b5d2e0d5240a4f4dacd7bb51c933e9feb9c5a57b86d5" => :el_capitan
    sha256 "25cff5a239d0ac3c9d72b2454c933de31328f34f35b23aa79dab7b369e33ed73" => :yosemite
    sha256 "fbe435923a587d89e3dc4ece4d9fd72bd6bff0deb6333169e448bade93201e5c" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "djvulibre"
  depends_on "libtiff"

  def install
    ENV.j1
    # force detection of BSD mkdir
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install Dir["#{prefix}/*.dylib"]
  end
end
