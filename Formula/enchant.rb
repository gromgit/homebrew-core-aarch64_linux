class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.2.10/enchant-2.2.10.tar.gz"
  sha256 "6a5b34c40647d8524b73a2b0d7104a6375504059ece61ae5ce459500d62cbdc3"
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
