class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.5.0.tgz"
  sha256 "5e7a6eecd21e3b2562de049f5c6f26ddd2cd2c42e939f0ed84cf9377d3acd1e1"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f1a35ef8092d5800b85eaa2779ab88723016d4f8b72206a7b361baccbec1c7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f1a35ef8092d5800b85eaa2779ab88723016d4f8b72206a7b361baccbec1c7d"
    sha256 cellar: :any_skip_relocation, monterey:       "96a566beedf2be7a7927da998105100cd403c9bcd32b0cfb5a2a6010109635b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0996c46132a6e6bc1207876cb86fced3f1267b74640e962055f89cab5b3fc94"
    sha256 cellar: :any_skip_relocation, catalina:       "c0996c46132a6e6bc1207876cb86fced3f1267b74640e962055f89cab5b3fc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f1a35ef8092d5800b85eaa2779ab88723016d4f8b72206a7b361baccbec1c7d"
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
