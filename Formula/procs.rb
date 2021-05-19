class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.7.tar.gz"
  sha256 "39758bb7070e8c3d2490a0ef5cad2cfaabf2e69be0c3a5e90c386507fe6e6970"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb7341372cafcde01168f2536528da72d6e888049b09aaa3fec9da352336d94e"
    sha256 cellar: :any_skip_relocation, big_sur:       "863b4116da671e1b2396b56fb92494037e9e044b744e06600ed6328c43973c5a"
    sha256 cellar: :any_skip_relocation, catalina:      "f6ce566e05165509d90e23e305d42d4bc20ce152d19d952b40767f91bbb6b74d"
    sha256 cellar: :any_skip_relocation, mojave:        "5792b8c02dd028ae321644809625acd6c94744bfd82ff9881add2be16ac6a1fc"
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
