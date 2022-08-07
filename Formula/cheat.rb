class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.3.0.tar.gz"
  sha256 "1e5bbaeca1bd3406afb03d696bd5e250189b4e11574c0077554150c2f054b8ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7bc9f3dce680fa74e76dec57b348f4b7d2c3b15ff7624f13065f958ea2fb7d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf1547313d3bedd3e2b5b82656aaa69387f561831b5fa7459c9738a504d96ba1"
    sha256 cellar: :any_skip_relocation, monterey:       "88206de162113a944ccb885d96818d4e45f40384d3a1131b74995425529eac8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "98d1722f991d3173f8d26e5a08f1a03cc55a258bc80a0caecc3135f8aa3bd9ab"
    sha256 cellar: :any_skip_relocation, catalina:       "9a17c87ca34307607bab3db039d16e3f2f82b95caad13529b62be369a5734158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2605aec7f33cb0a77c36260ecca46e96b1269d9145fd7192d3a3b1316ed83b06"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
