class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20220913.27dd36e.tar.gz"
  version "20220913"
  sha256 "7e3d575ae5dc5b4d6eb82e5d2b6c0322bc1ecabb9245d7c46417e6123f7dcd91"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78898d70b4e723eb3d1da639d006ad030cdecb063cf172f33b74595a54e54166"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0829dbf31c926d1d5ab38f3a9fa67756138770b120b584d3cd0d7b9cc6a4b9f9"
    sha256 cellar: :any_skip_relocation, monterey:       "34a03675e8665f28580452e1bed60137e763a9aa3af277f1e630338d6feeda7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bce35aebe3986e5dee56c50ee544dfcec9380c5a20c6e237292f4a3ac9cadfb"
    sha256 cellar: :any_skip_relocation, catalina:       "3dc75b765c8f1ad509f47f98b00ba9d531f6379753841f4b35d86a724fdb471a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b2d91dea2ce91b42cb14c45bb2cb88b10aea1fcd46351b764fc33cdb59c4f37"
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
