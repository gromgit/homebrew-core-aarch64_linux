class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.13.3.tar.gz"
  sha256 "aa93a588504dcc74df699d8a3bc2a27d3da94a772106a42d3d862a5fd17725c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bd1ea214ae9a040421ec2c2f5899ea6ce2b96b5dc94818c80a76e645e098e72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fe619a018f825ba5d2c9d2f139c0573996237e5aaf541476847bf169480d520"
    sha256 cellar: :any_skip_relocation, monterey:       "15af60f6cb0bdc6975403c26968ef657eff145c79571e973a97b1e8b338470ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "89c8c315d850b79e9b62222a393fd54389daa185193d9f53c354154bae60a47f"
    sha256 cellar: :any_skip_relocation, catalina:       "097223bca981e48634fe0c6b82c5610b900d5f9567fcc79a439c22f6d74dc4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c63ecc468c6f5fdc73863e103f9c58f3aca48281d8c1770bab626e4aef7fc7d3"
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
