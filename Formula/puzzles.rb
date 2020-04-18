class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20200413.2a0e91b.tar.gz"
  version "20200413"
  sha256 "fca9da3c80e5d1391f2f4bc94fd6536236ffacc4118e9f69ec7fc8a2c2170606"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c28cd47741725b21a24e43192a146ce89d4edeea80a6975af9b93fdf50c47293" => :catalina
    sha256 "8347af71af1dd079e17589f12757fdeee43b2264f76660873383ba0dce3334ee" => :mojave
    sha256 "7be4e1f28a39ac20178dc78c91000df079857588c96cf3e4b7b6516157203d96" => :high_sierra
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
