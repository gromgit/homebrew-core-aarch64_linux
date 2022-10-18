class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221016.879a692.tar.gz"
  version "20221016"
  sha256 "b1e34bc7ff15848108e40ad464d53daa4f6ad1162442cde7a6550aff6abc6f6a"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a62f452024086e6dbc85998b5fef7cc105f569a040d93629e25bbb279c78ae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e6cde7f4cd1543f721cce18964d0586c891725858f7eb26bad4069b8d77a61b"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c3b100f2dff47ab9866a30a4685e77570a601f430222c796e8b42127ecb8b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "171c8fd8ee9cd9a2b4f9f083ee47e064f450900256fe6a0e103d778494f302c2"
    sha256 cellar: :any_skip_relocation, catalina:       "f895c76b4f5afd856f19e32f8fad8ef542979ef592171e3dd0b89d212023d047"
    sha256                               x86_64_linux:   "999ea77272a4c18aba8e4a18117225f4b65de4ad951f179e2ce129c369d828d8"
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

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
