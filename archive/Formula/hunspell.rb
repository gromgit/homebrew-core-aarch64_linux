class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/releases/download/v1.7.1/hunspell-1.7.1.tar.gz"
  sha256 "b2d9c5369c2cc7f321cb5983fda2dbf007dce3d9e17519746840a6f0c4bf7444"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hunspell"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "be45c0efea97a1ce2d81cd61af48366b4055cc95e6954cbcb7b828be6bc9bb75"
  end

  depends_on "gettext"
  depends_on "readline"

  conflicts_with "freeling", because: "both install 'analyze' binary"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ui",
                          "--with-readline"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Dictionary files (*.aff and *.dic) should be placed in
      ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
      provides no dictionaries for Hunspell, but you can download
      compatible dictionaries from other sources, such as
      https://wiki.openoffice.org/wiki/Dictionaries .
    EOS
  end

  test do
    system bin/"hunspell", "--help"
  end
end
