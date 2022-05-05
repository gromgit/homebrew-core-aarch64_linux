class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.12.2.tar.gz"
  sha256 "14be8440fe85dc46e544a3f7e89b887db455a61db981d5f75b91fd89b366d84f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a13dce5e6266798af40688a6a1f323e0084d3ce9e199911e3f0523f13af658"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b7d2f32f3753035cc5c1cc19b697fa16d916e33aabc0b3dd68cba6d9fc318ca"
    sha256 cellar: :any_skip_relocation, monterey:       "278d61cdbd6fb7d0e0f00f4cbed41f3802cb8cdf9bed8ca3468b2abcb7253c59"
    sha256 cellar: :any_skip_relocation, big_sur:        "0539c269b9f0921486ecb443e6053aa93193f1e56d73d49245c7a12c448f1f6c"
    sha256 cellar: :any_skip_relocation, catalina:       "ac9da774b5b83fea1c55b3a4663a2a80d3b843c968b941bc3e420577e3fe3e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70af6a97ef22ef5b57340aaa69b0faa5b913f94cef0687daeffecd251f5b9ac4"
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
