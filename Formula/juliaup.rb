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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3431d17dcf908e8fded59b117bf42ef4569b87a483c2d0f1511789ceb0cdba3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5250b53f6bc926a5f4bb99cfa25f195b4c6fd222fff0f6bf1d1b69f0c634b148"
    sha256 cellar: :any_skip_relocation, monterey:       "2bc782c9f09e5b8989ed127fecfcfb3da04cf8cf062879308e01c6058b3334d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b69864a8197c98ab19ebc2c009403be126d4c45a975190e507ceaf0b6c7fcef3"
    sha256 cellar: :any_skip_relocation, catalina:       "c842ae971df2bd1ab95f869b8e0606da2d6c5ed2a6e9c00ea40162e8c3c2874f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1adb787eeb477bf53943570e06d70dad610e5da167b25c33d2126b24d17857a6"
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
