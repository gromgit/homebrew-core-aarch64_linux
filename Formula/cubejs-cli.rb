require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.20.tgz"
  sha256 "f180bdb64bb2b0c589de0ac9712e31f070b7c7f20c8990bb8a1a68ad9ff87e15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d7aa594c6d9148a15f0c8b0e1ab2065db6dd27cf062609890078324dfa7c41b"
    sha256 cellar: :any_skip_relocation, big_sur:       "39a7d7aa029f2442a370bc02f6e41891ef053662e241ab85f9ff23d342289077"
    sha256 cellar: :any_skip_relocation, catalina:      "39a7d7aa029f2442a370bc02f6e41891ef053662e241ab85f9ff23d342289077"
    sha256 cellar: :any_skip_relocation, mojave:        "39a7d7aa029f2442a370bc02f6e41891ef053662e241ab85f9ff23d342289077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d7aa594c6d9148a15f0c8b0e1ab2065db6dd27cf062609890078324dfa7c41b"
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
