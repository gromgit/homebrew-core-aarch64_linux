class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20210409.69b5e75.tar.gz"
  version "20210409"
  sha256 "6efc4939f8731d0613e47f9efdb01f0481d0a0c29c85435f59d78eae0fc444d1"
  head "https://git.tartarus.org/simon/puzzles.git"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b1eca473055fc6962f69daa3cb7367262e9dadf2a01e3223e1a2e7aff956b38"
    sha256 cellar: :any_skip_relocation, big_sur:       "40e28c1005919ab7dcbb215f5d51abbca00297816e0a4b170f4e0410d17cb713"
    sha256 cellar: :any_skip_relocation, catalina:      "ecdd353296ae643d50a67f5abbdac3d878ab3bc4fcb044b7a9d38b39ac281f43"
    sha256 cellar: :any_skip_relocation, mojave:        "aaf4ab9bb3026b8749235052b2f82eb7fb3f4eb8ad4ff418ebe35256f0421d99"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    on_macos do
      bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles"
    end
  end

  test do
    on_macos do
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    end

    on_linux do
      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
