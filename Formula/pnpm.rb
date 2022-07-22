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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c659dd7a1c969f1596fc7dbae2b8e360ebfeeb4d256c58397d7b2e13bb1037c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c659dd7a1c969f1596fc7dbae2b8e360ebfeeb4d256c58397d7b2e13bb1037c"
    sha256 cellar: :any_skip_relocation, monterey:       "41ac5a6a63c10c2b06db4bb9facbfd01b27fb65e55e641e7f76dd9dcb9fc57e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7023981c8080f3d5e63650e65a543f6715a600be992fe19565c6f1c5d6558033"
    sha256 cellar: :any_skip_relocation, catalina:       "7023981c8080f3d5e63650e65a543f6715a600be992fe19565c6f1c5d6558033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c659dd7a1c969f1596fc7dbae2b8e360ebfeeb4d256c58397d7b2e13bb1037c"
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
