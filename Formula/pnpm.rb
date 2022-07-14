class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.5.2.tgz"
  sha256 "ff766ecb180d8f259e4529db9bced008269749e3c3e8f1cd2cb70ee71c16179a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e14770d026c17a15b44a7b14ea09c62b8b02cf78a2e41de6bebd5adfb942123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e14770d026c17a15b44a7b14ea09c62b8b02cf78a2e41de6bebd5adfb942123"
    sha256 cellar: :any_skip_relocation, monterey:       "1d229abc0ad555a70aa574640045873bda4f6956fba9388614899b966da7bae4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2c88dae2d225c26f6ad5676271a5aa03e9273a9658557664e32116b492336a7"
    sha256 cellar: :any_skip_relocation, catalina:       "a2c88dae2d225c26f6ad5676271a5aa03e9273a9658557664e32116b492336a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e14770d026c17a15b44a7b14ea09c62b8b02cf78a2e41de6bebd5adfb942123"
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
