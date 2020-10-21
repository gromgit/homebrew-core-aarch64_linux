class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.6.tar.gz"
  sha256 "1fceec81e9647aa7798e48e5bdd41367423cb8a0932a234eacbb95a3679997ed"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c589ba782855ad7953a724d12ca67176969d15f17a0166fdea4f77f98c27dc58" => :catalina
    sha256 "624a513a7a5092460e07b714f9d354f9c99deba6e1f76f22f60b20e8e25cc21b" => :mojave
    sha256 "45313e5de3755a72d4f8b1ff87bc486d596710df6cde1140b847d48a84489d28" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
