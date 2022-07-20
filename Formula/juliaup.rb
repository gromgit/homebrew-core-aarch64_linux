class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.11.tar.gz"
  sha256 "0c58a2f56d238ed8d81b29325229872fb70ea3c6b5b13d59d2d40abd6de743f1"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63e1f181f0cccdb6e310bc504b756d73115b376401835ed6f11d1d3b2ee7268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cc5baacb55d2e1fa244c9b1fb56335d924a868c48dbbbb0cdfddd7d90a4deee"
    sha256 cellar: :any_skip_relocation, monterey:       "593aee5caa5c0d91247d800d8f25f60f1590299bd28d4035c8f60342d3f39ec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf6144d81d3d60ad07bbe3f92e7b7857845cfe56933163c884a4b62623c985f6"
    sha256 cellar: :any_skip_relocation, catalina:       "ba506ad4af49230ea519bb082cc04f42290624790fd257f47ce305a2577c9b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5762123761022ad49832460d3becfa0454bd2b838656e1f84a50ec4273ff147"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
