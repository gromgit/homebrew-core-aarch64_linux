class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.3.2.tar.gz"
  sha256 "ea40ebfef2d126c627e39a4e3c2aaf3a6b9bcf6489992430fb30fb42b13dab16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75c5c4b4a534e0f2f66a515832f26716362797741b7f2b10ba2fe9ccd3ba4cb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6f66cd80b18fec6f7ee048e2f26223ff69f92c8a7c41ed46128aed797079958"
    sha256 cellar: :any_skip_relocation, monterey:       "418753455cbc979237ff1064db90126f50057839a91ff09aea883f1ece434b0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5962c9a7260c806d10d6d1390292992ffb6b76998b38a06f2e92005b990ec91b"
    sha256 cellar: :any_skip_relocation, catalina:       "4a74092dfbbcd49854da13b54fec2e7a4b6b5b886f836601c56181aeb712db85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c4be83cf164047fa585c0bb63aaef2414540448314d3246a15e1c323bd261a6"
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
    assert_match "editor: EDITOR_PATH", output
  end
end
