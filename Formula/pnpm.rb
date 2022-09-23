class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.12.2.tgz"
  sha256 "e299cd53fb4e4203d568c8e7641bf116f9f1c11b44d06a1cab67a09da63358e3"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0bb25600fee29e88f50599d6735ec3bd8810c4206c014d789fa34d7d6e1dfae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0bb25600fee29e88f50599d6735ec3bd8810c4206c014d789fa34d7d6e1dfae"
    sha256 cellar: :any_skip_relocation, monterey:       "a08cefe305f8cd1e6038e09d72f85d305e00253b3a299fa4252778de6fa4dd84"
    sha256 cellar: :any_skip_relocation, big_sur:        "a45e5322e587f4a2a32af2b8c073f8dbe7cd6d21b5d03f91cbf2a8a4cd862a33"
    sha256 cellar: :any_skip_relocation, catalina:       "a45e5322e587f4a2a32af2b8c073f8dbe7cd6d21b5d03f91cbf2a8a4cd862a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0bb25600fee29e88f50599d6735ec3bd8810c4206c014d789fa34d7d6e1dfae"
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
