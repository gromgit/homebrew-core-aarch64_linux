class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/v3.0.13.tar.gz"
  sha256 "ecc27f272792bc8909d14f11dd08f0d2e9bde4cc663b3769e00eab6e65328a9f"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/exercism"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "300c0ab5ee54ff032ac2dbbf77ecd617d2668d5d4a1da1d497656b8e176f79de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"exercism", "exercism/main.go"
    prefix.install_metafiles

    bash_completion.install "shell/exercism_completion.bash"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
