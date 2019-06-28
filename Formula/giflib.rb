class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz"
  sha256 "31da5562f44c5f15d63340a09a4fd62b48c45620cd302f77a6d9acf0077879bd"

  bottle do
    cellar :any
    sha256 "b928306b53fa61057ba9bd7515b705c7dad9138b2c524e66313fa12dca507497" => :catalina
    sha256 "8b928fd9ce46279d60a9ac73f795f3e068cc1478fcae4aabc8f7231d972820ec" => :mojave
    sha256 "0c9517138125951ae8fd38f026aa970bb877f1ae7564e47863cdf64a2adebb2e" => :high_sierra
    sha256 "a298e371464c6bcbe67c5f0c8b23de398980ad3a5ac3e8507f0ee29fef0c9e13" => :sierra
    sha256 "91161dd227491e058a9ca79ca89bb647d2bac5e368bed5457fc80a30d383ff2d" => :el_capitan
  end

  # Upstream has stripped out the previous autotools-based build system and their
  # Makefile doesn't work on macOS. See https://sourceforge.net/p/giflib/bugs/133/
  patch :p0 do
    url "https://sourceforge.net/p/giflib/bugs/_discuss/thread/4e811ad29b/c323/attachment/Makefile.patch"
    sha256 "a94e7bdd8840a31cecacc301684dfdbf7b98773ad824aeaab611fabfdc513036"
  end

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end
