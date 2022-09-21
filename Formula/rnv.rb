class Rnv < Formula
  desc "Implementation of Relax NG Compact Syntax validator"
  homepage "https://sourceforge.net/projects/rnv/"
  url "https://downloads.sourceforge.net/project/rnv/Sources/1.7.11/rnv-1.7.11.tar.bz2"
  sha256 "b2a1578773edd29ef7a828b3a392bbea61b4ca8013ce4efc3b5fbc18662c162e"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rnv"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b7b04d66d23f2a9b804d9934a529ec571de72051f90dddc162ea01923c48056d"
  end

  depends_on "expat"

  conflicts_with "arx-libertatis", because: "both install `arx` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
