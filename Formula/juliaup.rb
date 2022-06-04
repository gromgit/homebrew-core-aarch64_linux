class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.6.4.tar.gz"
  sha256 "9dd289e9a5d932adb6d18fdf9f3758d88eea96d2faaaf0bc86e8583bde0e9eb6"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f630ad6bb771ac6f00f9f43092b64142e2f1cf2ca16b6a2fbcb381384190d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00d94ed5c4284755dcb260f169a57e452c5605d6d1f18cbf693189505f610b20"
    sha256 cellar: :any_skip_relocation, monterey:       "d22725f258364192df8ba4b5473e92b6a1fd40e130f1e797ef7340b795acdd0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "893567c4977677595852b7ea3c9602792079cff4694cb9341fbc59dfb6a7f2d2"
    sha256 cellar: :any_skip_relocation, catalina:       "c4b347230281b010b903bb209d06c9294eab7124f9c98d4d5a51ac4260b26c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "172ba405fbc901561504b8f9b84d820b66b7dad1fb037c84db50063830aa07d5"
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
