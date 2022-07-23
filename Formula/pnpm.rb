class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.6.0.tgz"
  sha256 "693eb1e1aa5c61cb7468998202a33209523aaa11f5ab0878074fe1aa55578148"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc2d383de124a923740794d4d1c01383b511e22e7e71c50f471f599530ade05a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc2d383de124a923740794d4d1c01383b511e22e7e71c50f471f599530ade05a"
    sha256 cellar: :any_skip_relocation, monterey:       "2bd24add2812d9ae478468f596b1a46ff59da2b1c7550af8a41b7edf396bca36"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f9a883fc652efaf1d63bcd8e8db43c9cb4d81e12d9b8076b10e342c2ba20df2"
    sha256 cellar: :any_skip_relocation, catalina:       "7f9a883fc652efaf1d63bcd8e8db43c9cb4d81e12d9b8076b10e342c2ba20df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc2d383de124a923740794d4d1c01383b511e22e7e71c50f471f599530ade05a"
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
