class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20200524.66b9e8c.tar.gz"
  version "20200524"
  sha256 "0509039291b384d85835e726ac0db9cee850e9466da01f96be35e046a3869358"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "feb80a8da8591259aae67f3594e9eec1dca17d32a25822147bec353eed6830ae" => :catalina
    sha256 "77448c9b84c0c293473abbb5345d31b4bb984d7fb24d3be62ebe3103beda3abb" => :mojave
    sha256 "b6f43fec8b75e417f5be8acc4a765583a98df03b62a0f9f43e168599ed6a90b8" => :high_sierra
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
