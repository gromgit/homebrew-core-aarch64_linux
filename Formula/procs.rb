class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.13.1.tar.gz"
  sha256 "29a5058f8389986e5b17117d3ee4f78a2bf9c8886e07b16a49a94e5fc59a6850"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17e8bfdcbda59e63ebb95355cab2f68610c8dc2f7431f0bccdfdc8bdbf741a81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb3fdbbe55e7addc2f10cb058a124475cc5b8851c5e323aa565b6a64e0baba03"
    sha256 cellar: :any_skip_relocation, monterey:       "8cca4cf1b843200f8b0a6d2bd935ca647ed74242490ac57ebfebaada3c6b1037"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2d0e607ad4e282ba9d529f261ba99b2c059323e23e7ba726c8e07fd44f9b560"
    sha256 cellar: :any_skip_relocation, catalina:       "577d41ffda4ab435ed507fc80c566b0184f230776c813dc84bbada1b32fbe7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd5e9324e8dae71349ee60cff89b8e17fb314befd104c7b667fd5c50d1fc8230"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--completion", "bash"
    system bin/"procs", "--completion", "fish"
    system bin/"procs", "--completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
