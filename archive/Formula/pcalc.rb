class Pcalc < Formula
  desc "Calculator for those working with multiple bases, sizes, and close to the bits"
  homepage "https://github.com/alt-romes/programmer-calculator"
  url "https://github.com/alt-romes/programmer-calculator/archive/v2.2.tar.gz"
  sha256 "d76c1d641cdb7d0b68dd30d4ef96d6ccf16cad886b01b4464bdbf3a2fa976172"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pcalc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b6bc63dfb0494b0c914fb47e93848ba21c0edea56f614753df2ec4c26a1e5713"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "pcalc"
  end

  test do
    assert_equal "Decimal: 0, Hex: 0x0, Operation:  \nDecimal: 3, Hex: 0x3, Operation:",
      shell_output("echo \"0x1+0b1+1\nquit\" | #{bin}/pcalc -n").strip
  end
end
