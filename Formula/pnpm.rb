class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.12.1.tgz"
  sha256 "614e86e5ea3be20e9f614b6ea525189bc28e93e1f6d0ff84d51d8a49d9aa1200"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "618ab80b2f80fb392689bfc8d1d2111ce2f510c4b067e0ea1b718ee06b69b18b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "618ab80b2f80fb392689bfc8d1d2111ce2f510c4b067e0ea1b718ee06b69b18b"
    sha256 cellar: :any_skip_relocation, monterey:       "59370095928f6e08806f1cc637a32f9415a2a836f3e507c5c9b33483a93ac9ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "c476c1ba03236275afb627851c2f9c1e8614af23aac56198e8f4177316a0bdde"
    sha256 cellar: :any_skip_relocation, catalina:       "c476c1ba03236275afb627851c2f9c1e8614af23aac56198e8f4177316a0bdde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "618ab80b2f80fb392689bfc8d1d2111ce2f510c4b067e0ea1b718ee06b69b18b"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
