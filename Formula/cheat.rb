class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.2.5.tar.gz"
  sha256 "727c19efb873e6ea29b922a480074da8e5b73a0d129c3277539484a736527033"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "323ea8909029c5871a8de7ce998d27d5264182b2a5e9c117263825ed973225b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aef9cf4c3a854269193bc6be898d719525008f336f03e456fc1f9ac5e96a0a39"
    sha256 cellar: :any_skip_relocation, monterey:       "69d6defe80f399eaad96eac7d091b24d9576340e954c0d68db05076ca01d4432"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9f5a1f3b1d0d0e1bdbf9b26cf252159cf2736a0deea80f56fb29c44a3161c46"
    sha256 cellar: :any_skip_relocation, catalina:       "2d587b6cec73671b5b88d2f4b48b27c52f7267337e88811c28aac919a4d5255d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a527193164ccc9ad7f4775633ee21eae645144217a6b8b6f499c43432c79cd4"
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
