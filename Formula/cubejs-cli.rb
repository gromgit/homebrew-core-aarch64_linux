require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.4.tgz"
  sha256 "4924f2986db7e2e2c2e773c7650909f5f082944255ee5faa0fd683e88dfb61ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a8f2b80767f06ca18650670a83d9625858216a3496fba0cbe71d418338a10e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a8f2b80767f06ca18650670a83d9625858216a3496fba0cbe71d418338a10e6"
    sha256 cellar: :any_skip_relocation, monterey:       "76417d41195dbd5e4612a29feae4d198c2e1cef9d9a4752bf4bd4a58381d0592"
    sha256 cellar: :any_skip_relocation, big_sur:        "76417d41195dbd5e4612a29feae4d198c2e1cef9d9a4752bf4bd4a58381d0592"
    sha256 cellar: :any_skip_relocation, catalina:       "76417d41195dbd5e4612a29feae4d198c2e1cef9d9a4752bf4bd4a58381d0592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a8f2b80767f06ca18650670a83d9625858216a3496fba0cbe71d418338a10e6"
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
