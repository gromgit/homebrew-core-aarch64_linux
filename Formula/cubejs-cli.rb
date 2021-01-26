require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.29.tgz"
  sha256 "be898558be82ec5693ddcea4eede99d78eea8fa2251787ad8641f26ffe22427c"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a6346b435a88c93a6963acddc230fdf0f2db6cb3d16620063a108d360db6a3b0" => :big_sur
    sha256 "7678016a72a347ce9b96798b32e51bf2aefd033a9068eaf8c757faf250e8f3a4" => :arm64_big_sur
    sha256 "12f4df988e5b17d87ec818b9bdb1c0622ca7320f00a4733a8ac5a0c0d3b1dcd4" => :catalina
    sha256 "559703ae6b56e1e4ae1e17db993866c8a5e073f069065df1dd15de093f23828b" => :mojave
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
