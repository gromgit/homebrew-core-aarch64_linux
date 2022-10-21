require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.5.tgz"
  sha256 "2a953910145f24c189aee205ba2973ec5ffcff4ec3b7aa203caf7c8f6f5a978e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "513f446196f50b5f6de729a78a019635de9b2adb9282ed6d966efb50af512e5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "513f446196f50b5f6de729a78a019635de9b2adb9282ed6d966efb50af512e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "694fd694cf5aedb6d147c286797a1dc2b27e2482cf62374831f26ed0f47334bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "694fd694cf5aedb6d147c286797a1dc2b27e2482cf62374831f26ed0f47334bc"
    sha256 cellar: :any_skip_relocation, catalina:       "694fd694cf5aedb6d147c286797a1dc2b27e2482cf62374831f26ed0f47334bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "513f446196f50b5f6de729a78a019635de9b2adb9282ed6d966efb50af512e5f"
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
