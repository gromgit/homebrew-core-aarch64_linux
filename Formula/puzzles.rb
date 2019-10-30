class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20190902.907c42b.tar.gz"
  version "20190902"
  sha256 "5aad2076f1b748a854f1590f31fbcfc23cc91bf08ce4a3f270bad7cd11e6766f"
  head "https://git.tartarus.org/simon/puzzles.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24c9c23f85d0027f7ae1039295f61a39f4bf4db7004df9fc3c003fe8d9ad3440" => :catalina
    sha256 "24c9c23f85d0027f7ae1039295f61a39f4bf4db7004df9fc3c003fe8d9ad3440" => :mojave
    sha256 "aee29ff690bc65b2f098c4890a02e78e35a9859eb86e78514274ca45fb442695" => :high_sierra
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
