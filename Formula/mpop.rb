class Mpop < Formula
  desc "POP3 client"
  homepage "http://mpop.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpop/mpop/1.2.0/mpop-1.2.0.tar.xz"
  sha256 "9d28817a6950f64aadf10bf5841400701917102181ebf96c136fbd4707c17ba7"

  bottle do
    cellar :any
    sha256 "d0cf8dbb1e38b7cecd1e7bb25b36d030ba84dcf7ba9fea9c7ba85a079dfac5c9" => :el_capitan
    sha256 "74065aba089ad65eeae5981b1959e82ab0780c05cceefeb7bf1c70a7ecb90289" => :yosemite
    sha256 "44711199cbcfc5903eaf7032da4fa390888e507f836d28e00ee027a98ec9d668" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
