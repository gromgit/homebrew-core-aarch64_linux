require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.1.tgz"
  sha256 "6eec8722d2a6c3a813f846a81203412cb7bc5304ffef8eb00ce5283213b8376c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72da66fa3acda84a61b7db469f751c484cc6f144c5338caf0c8519ef5ebe2d30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72da66fa3acda84a61b7db469f751c484cc6f144c5338caf0c8519ef5ebe2d30"
    sha256 cellar: :any_skip_relocation, monterey:       "18198e8bb3c0716b0779c2cb5f1231defcfc15cdce2a44a81912ef822cfd00fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "18198e8bb3c0716b0779c2cb5f1231defcfc15cdce2a44a81912ef822cfd00fa"
    sha256 cellar: :any_skip_relocation, catalina:       "18198e8bb3c0716b0779c2cb5f1231defcfc15cdce2a44a81912ef822cfd00fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72da66fa3acda84a61b7db469f751c484cc6f144c5338caf0c8519ef5ebe2d30"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
