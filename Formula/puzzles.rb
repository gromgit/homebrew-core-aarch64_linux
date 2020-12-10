class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20201208.84cb4c6.tar.gz"
  version "20201208"
  sha256 "fd49aabdd7c7e521c990991dab59700a40719cca172113ac8df693afe11d284d"
  head "https://git.tartarus.org/simon/puzzles.git"

  livecheck do
    url "https://www.freshports.org/games/sgt-puzzles"
    regex(/puzzles[._-]v?(\d{6,8})\..*?\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4da306f66d6c8cfba1b0454dc82d23c3614236703e5155ddfb2b9a7f6e2a07a1" => :big_sur
    sha256 "ceafdd23c80d3b19927950e42b87589c577842e0617771cf3cda4696215ad201" => :catalina
    sha256 "0aefe3d23e5dc7a2a8ef7414b81f5ebc12566b0b712d67c7328f7ceec67bb6cb" => :mojave
    sha256 "e70e7726c99542aa47fd5ff918a121ca0967c3ef5ab4e69d026eefb63141d8ff" => :high_sierra
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
