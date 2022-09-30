class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.7.24.tar.gz"
  sha256 "1f9525c0cc229cd582c60a4cb6c68d07a95704548e02d668a714149b5cfaf6fe"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2487ce26d253ad61a73d0e00918827c3f931fe661c21e0fe14f5fe853fa29c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc0984f51f2abb146ab734630916258e97b3e8229ea03c630a85bb02969fbda0"
    sha256 cellar: :any_skip_relocation, monterey:       "7f48d50a44cbf56b5127d255641b179314fc45847ba40eb7f81f0f18a666abe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ff859b9a30301078b1803f0a798bf1fb33b3af5c17cc3a96eefba65fed0259a"
    sha256 cellar: :any_skip_relocation, catalina:       "45d6d3ac5b7e517fd1f06077bddd11fbc4afe92963342111663eb4173e1c0317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2afb8b6d7fbc6d9bb91d2bb1a8b75618a9f290c44684453440d56a9a6dc4a6f"
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
