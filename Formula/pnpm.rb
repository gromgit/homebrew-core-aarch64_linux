class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.15.2.tgz"
  sha256 "8b1701722ac1ffba3edbd2ea06c23c0385ee85d190ab425f17d215dfae0d3b2f"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89e158f1a6bc6f5348e410110acfcbab396cd4989b68d6558b01af0e801e9d22"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a205d6a45daf68c0c97c0b27f9ddb45d2649952ba1f6886bb017b555b70f678"
    sha256 cellar: :any_skip_relocation, catalina:      "6a205d6a45daf68c0c97c0b27f9ddb45d2649952ba1f6886bb017b555b70f678"
    sha256 cellar: :any_skip_relocation, mojave:        "6a205d6a45daf68c0c97c0b27f9ddb45d2649952ba1f6886bb017b555b70f678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e158f1a6bc6f5348e410110acfcbab396cd4989b68d6558b01af0e801e9d22"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
