class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.3.3/enchant-2.3.3.tar.gz"
  sha256 "3da12103f11cf49c3cf2fd2ce3017575c5321a489e5b9bfa81dd91ec413f3891"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/enchant"
    sha256 aarch64_linux: "7224bf7c1893e8b72d48ee1b8d506c3916696208232353639726e24ebdbaa55c"
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

    # Explicitly set locale so that the correct dictionary can be found
    ENV["LANG"] = "en_US.UTF-8"

    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
