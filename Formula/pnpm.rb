class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.20.1.tgz"
  sha256 "185e6199d9b7ba30d2a4129776eecbb82d78046616ea94b5a839044451b1a271"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e7a1f4a6c9ac6ab3ad2196e33b6a5cdd61745dd618ebcad1217c87dd236973f"
    sha256 cellar: :any_skip_relocation, big_sur:       "6de0105c973d38d6091b1bdef3e83fbe9577e7c21304c1dde5f87a5eba758bb8"
    sha256 cellar: :any_skip_relocation, catalina:      "6de0105c973d38d6091b1bdef3e83fbe9577e7c21304c1dde5f87a5eba758bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7a1f4a6c9ac6ab3ad2196e33b6a5cdd61745dd618ebcad1217c87dd236973f"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
