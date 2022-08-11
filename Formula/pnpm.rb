class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.9.1.tgz"
  sha256 "9031367b1dbb8f83ed7e62f0b6785e3c1d103f6738ef8f619f14edcccd24a04a"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d27eed054dd8dd0690bed65ecff6fce71254f37db1f577e32a8ae505e37d5ecc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27eed054dd8dd0690bed65ecff6fce71254f37db1f577e32a8ae505e37d5ecc"
    sha256 cellar: :any_skip_relocation, monterey:       "7e33fabee89c771c4c1c7a3f9acedb28333f4b50d07ebffd4508839de7987320"
    sha256 cellar: :any_skip_relocation, big_sur:        "c39fe39f09ad6da258cedc60257d194c69f29c84f0f610226cff326dcfa3925a"
    sha256 cellar: :any_skip_relocation, catalina:       "c39fe39f09ad6da258cedc60257d194c69f29c84f0f610226cff326dcfa3925a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d27eed054dd8dd0690bed65ecff6fce71254f37db1f577e32a8ae505e37d5ecc"
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
