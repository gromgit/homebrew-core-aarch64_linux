class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.11/enchant-2.2.11.tar.gz"
  sha256 "a29c5777c4e45fcac2595c15c49d6d2aa434fa5e7c993dff3f9f367b65fe472a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 "39e25649a0a6db39b04f86b4c1ff46c679195c7ac2c4582fad10a373fb2a387b" => :catalina
    sha256 "5116e6a96d4ffc9dc06c9ec95b2ab5053fc19ebc14d3364af41fca72db01380e" => :mojave
    sha256 "b19939040a5a84e6d9025acf06cef0205e6c0b0236985f565a40d5f1201a553b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable"

    system "make", "install"
    ln_s "enchant-2.pc", lib/"pkgconfig/enchant.pc"
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh lAzy d0g"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpath/file).write text
    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
