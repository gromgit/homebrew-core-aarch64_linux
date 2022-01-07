class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.25.0.tgz"
  sha256 "9c7a27d321529c62e28625801ffbfdf03bc9328cb82486f34c1a9098af22a609"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5977161780dc291b7fde630fcbb5861a1fe8cc532c776009bc747f54dc5831d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5977161780dc291b7fde630fcbb5861a1fe8cc532c776009bc747f54dc5831d0"
    sha256 cellar: :any_skip_relocation, monterey:       "4c991e22dc495d72dbcf8db371139284520a97ef3cfd71e80f0f317280483743"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5109c5ade8a8c994f2e82a3be861343d25f726e8c030f963b24a3ee0a8e0610"
    sha256 cellar: :any_skip_relocation, catalina:       "f5109c5ade8a8c994f2e82a3be861343d25f726e8c030f963b24a3ee0a8e0610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5977161780dc291b7fde630fcbb5861a1fe8cc532c776009bc747f54dc5831d0"
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
