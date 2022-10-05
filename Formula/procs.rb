class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.13.2.tar.gz"
  sha256 "521b25cbb3fac8b6f3cfd33c4d58f269e7d6637a89f6b932f144a8bed7914ec0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ec53eb05056becc3c646631c1f532b13599805143435d0501627ff18b886719"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1bc61db1c384ae52a7752a9fde836a95fe6bc4c15d31fdcac44e8b8edb1cba6"
    sha256 cellar: :any_skip_relocation, monterey:       "c7b170778aa6d466f9624db2169e2fb70d4a825b02c5d87d45017e9d21528b70"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b2660ff574f21ec9489d606ae391595a6738d6c583158aa5bffbb6f85c9a9e2"
    sha256 cellar: :any_skip_relocation, catalina:       "505dad2cfc7c3a485b71bfb1663d4c1cc6ea9dad10be68e86ea4013622c17555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba36e88d9d9e3a1da59461a5cdd91480828667b6011b5f99a5541e3cd0f641b"
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
