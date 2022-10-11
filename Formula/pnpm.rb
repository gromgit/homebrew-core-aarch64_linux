class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.13.4.tgz"
  sha256 "ef9d3eac337b5bb88963e939e7a0cb50e5645590e5583965d443cb9e42a279c7"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fdf07bc091ca68a02d15cad83112ff8ffde3886cdc9f71472c0f9e482ffbece"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fdf07bc091ca68a02d15cad83112ff8ffde3886cdc9f71472c0f9e482ffbece"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd64efaeabd93ea0d5267bbd48d603917fd695c4f5dc7de138fc2fe061f397f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6262e97ea1ac29e8b824bccd770dbe2f8e862a651d8a9077c1771d35fc9a2dfb"
    sha256 cellar: :any_skip_relocation, catalina:       "6262e97ea1ac29e8b824bccd770dbe2f8e862a651d8a9077c1771d35fc9a2dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fdf07bc091ca68a02d15cad83112ff8ffde3886cdc9f71472c0f9e482ffbece"
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
