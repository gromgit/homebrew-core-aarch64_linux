class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.2.5.tar.gz"
  sha256 "727c19efb873e6ea29b922a480074da8e5b73a0d129c3277539484a736527033"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5b688f664d1a90636f0793caff1e8fb1547050ca83d1490ed815580b7b1a41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0c6f4461f88d303b7a49ac0d780a5889d6e9ef11504ffcc1ee91b24b1cda11a"
    sha256 cellar: :any_skip_relocation, monterey:       "0508db513b9066cb899e4315497c2546146a1b5a27a3e09913a7e3560cba3277"
    sha256 cellar: :any_skip_relocation, big_sur:        "0741741fe225b99ed5920ef1038d5de247d217f89a32b1be92c7f38e8d20a674"
    sha256 cellar: :any_skip_relocation, catalina:       "f3b4476b73616177a4694ad45e54a4abb3b972a69d613ab65749e4f13d9de704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad759f0cd1a173289659e881a712388ed4989b9b5f0dcec94a45f473d8c400c"
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
