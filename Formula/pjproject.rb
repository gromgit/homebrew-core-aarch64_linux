class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.4.5/pjproject-2.4.5.tar.bz2"
  sha256 "086f5e70dcaee312b66ddc24dac6ef85e6f1fec4eed00ff2915cebe0ee3cdd8d"

  bottle do
    cellar :any
    sha256 "22be2e11f2538808f10aace043fb3096bfa7210bfe18eccd923e107b3c724311" => :el_capitan
    sha256 "3ee6735dd996f8963d0d47cdd0019fb144485b3e10b604589f99164abd757c10" => :yosemite
    sha256 "dae64c57018f78472c465c0f70883176d4edb5ceee27e93a8c1df448c8700fe8" => :mavericks
    sha256 "ebe8c9879332a77a90523f4791c70c109f57ffcecc176e77e2acdcb47bacaa3d" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"
    bin.install "pjsip-apps/bin/pjsua-#{`uname -m`.chomp}-apple-darwin#{`uname -r`.chomp}" => "pjsua"
  end

  test do
    system "#{bin}/pjsua", "--version"
  end
end
