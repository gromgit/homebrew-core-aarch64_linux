class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20191231.79a5378.tar.gz"
  version "20191231"
  sha256 "c3697593ce2dfdc742bec4cc55848c18c612b1fab8362d5003def834b7056dd2"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a961496e5300cde27bc88ebca82dc1e75a03f2d15025ffa48c243a4aa1792f0a" => :catalina
    sha256 "a961496e5300cde27bc88ebca82dc1e75a03f2d15025ffa48c243a4aa1792f0a" => :mojave
    sha256 "420e204a6170b7e2d1a4318bb96817a738a5a4cd3bec383e1ca7c3aed4602800" => :high_sierra
  end

  depends_on "halibut"

  def install
    # Do not build for i386
    inreplace "mkfiles.pl", /@osxarchs = .*/, "@osxarchs = ('x86_64');"

    system "perl", "mkfiles.pl"
    system "make", "-d", "-f", "Makefile.osx", "all"
    prefix.install "Puzzles.app"
  end

  test do
    assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
  end
end
