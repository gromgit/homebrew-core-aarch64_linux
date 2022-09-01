class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.3.tar.gz"
  sha256 "1e07203546274276503a4510adcf5dc6eacd5d1e20604fcd55a353b3b63c1213"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d11c987e9212abab48e2d8181f4c7c0c0d7643e10fae9a80c4628d26252342f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "324f6daf723a7667906c4929a7676959908d490ff2f8172e01d80002ca4a9928"
    sha256 cellar: :any_skip_relocation, monterey:       "f501c9625ec7e9e137d26445cf060f0d2dfa3eb961eace0a397a85f8901a20cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "df9740dfa5ba908598af62bbed19c51da45a95a8a9f1734649cfeb12189ff0b6"
    sha256 cellar: :any_skip_relocation, catalina:       "c3b34a576b08a9f6077e72867838dbeadeced2805f0098ecd1320b9a16ecbd3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07e4591c6db357142330cecdba01de52917be0b472bd35fb557cde2be5fb152e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
