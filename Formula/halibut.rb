class Halibut < Formula
  desc "Yet another free document preparation system"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.3/halibut-1.3.tar.gz"
  sha256 "aaa0f7696f17f74f42d97d0880aa088f5d68ed3079f3ed15d13b6e74909d3132"
  license all_of: ["MIT", :cannot_represent]
  head "https://git.tartarus.org/simon/halibut.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edd2a0fb184a9f0b782886d86d149dbc400fc3c32488fe089603e111147a3f88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbe2900f2e05ece4838ae138e287192fce7c97ed648994f15b19c91304e26154"
    sha256 cellar: :any_skip_relocation, monterey:       "7274b17081b5c45aa8986ed7d1d02e1b0f8e95c519e8a5cf5a04bbc1798450dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f3dc434449de2f5d18bb5019dc62a966cba2981eb88d59d77d34b2049e44f2d"
    sha256 cellar: :any_skip_relocation, catalina:       "e9bd74c1ab130f4abc824906bf1f73f910032a4c7c0938798f7fbab2f1346020"
    sha256 cellar: :any_skip_relocation, mojave:         "05f0236c180aeab690979615812fb72642e7cdeaccb35ebb865a53aadb35e7c6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fe74b9670ae0d996a17de4a70a140365d057a83a643125dcbd16b33dacad9f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f37d878d7f5d8a0869220fc00abdad12f298da1cdb1d2541b3f66793f749e9b4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"sample.but").write("Hello, world!")
    system "#{bin}/halibut", "--html=sample.html", "sample.but"

    assert_match("<p>\nHello, world!\n<\/p>",
                 (testpath/"sample.html").read)
  end
end
