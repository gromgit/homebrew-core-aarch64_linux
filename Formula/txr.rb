class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-232.tar.bz2"
  sha256 "e96b01ce378c21cfbbc69de3c9ff22cd92bc0878c3dfd0356367300154dcab61"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "79c2b3ba017b621bc3a7aea16ec0126b6fc1477cbe5b5c3d483c25c5620cf677" => :catalina
    sha256 "9185383b8ca55f43ac0713f0c4fb24649e6b2f01ebd4decb66e0978d6010aecd" => :mojave
    sha256 "84544b80f30a8f5d96403a7b6380bdc452adb30634ad1cef29420f28ebf9b867" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
