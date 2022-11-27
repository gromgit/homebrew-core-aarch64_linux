class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.3.tar.gz"
  sha256 "ba898331d76e266ae3af4e5eab5c6af30ef004c133104fec3e0bbb9497f5c70a"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/circumflex"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "dee07f875f45a8774bb8e62df89ce5c47e4057507961cf9728ff5fa8f6b6259a"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  uses_from_macos "less", since: :monterey

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
