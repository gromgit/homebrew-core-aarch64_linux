class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.2.tgz"
  sha256 "839b1b6c3b6504f08a56d78aa38d35d48bba76684fe391229f112c65e25f0862"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb5402a67b45287dc1bb01f5f42c2059e3f19f2c7c2a2ff85bc167c9fb504760"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb5402a67b45287dc1bb01f5f42c2059e3f19f2c7c2a2ff85bc167c9fb504760"
    sha256 cellar: :any_skip_relocation, monterey:       "e9bd6da37975025d45739a289e0d4e50a1dea864f3731a74fae161325a61cac2"
    sha256 cellar: :any_skip_relocation, big_sur:        "99c18eacf042b74895ddfafb54f3e7e55f57226ba1883c281cd862e3934ac317"
    sha256 cellar: :any_skip_relocation, catalina:       "99c18eacf042b74895ddfafb54f3e7e55f57226ba1883c281cd862e3934ac317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5402a67b45287dc1bb01f5f42c2059e3f19f2c7c2a2ff85bc167c9fb504760"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
